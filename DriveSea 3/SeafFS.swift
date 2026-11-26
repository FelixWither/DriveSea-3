//
//  SeafFS.swift
//  DriveSea 3
//
//  Created by FelixWither on 2026/11/17.
//

import Foundation

final class SeafFS: NSObject {
	private let lock = NSLock()
	
	// MARK: - 3-Tier TOC caching
	// Repo name → Repo UUID
	private var repoIndex: [String: String] = [:]
	// repoIndex["My Libraries/Repo_Name"] → repo uuid
	
	// Path → Entries under the path
	private var dirCache: [String: [String]] = [:]
	// dirCache["My Libraries/PrivateLib"] → ["12315", "Books", "CodeLib", ...]
	
	// Path to file → File attributes
	private var entryCache: [String: DirInfo] = [:]
	// entryCache["My Libraries/PrivateLib/a.pdf"] → DirInfo(type:"file", id:"…", size:2341233, mtime:…)
	
	private var loading: Set<String> = []
	// File list for files that are loading
	
	private let fetchQueue = DispatchQueue(label: "drivesea.fetch", qos: .utility)
	var volume: GMUserFileSystem?
	// For assigning a pointer to volume, so we can trigger refresh.
	
	private static let systemProbeNames: Set<String> = [
		".Trashes", ".fseventsd", ".Spotlight-V100", ".TemporaryItems",
		".DS_Store", ".localized", ".hidden", ".VolumeIcon.icns", ".background"
	]
	
	private struct DirectoryTarget {
		let repositoryID: String
		let innerPath: String
	}
	
	// MARK: - Private helper functions
	private func normalizeKey(_ path: String?) -> String {
		let p = (path ?? "").trimmingCharacters(in: CharacterSet(charactersIn: "/"))
		// Remove the "/" at the both ends of String
		return p.precomposedStringWithCanonicalMapping
		// Normalize the String, see Wiki
	}
	
	private func fullPath(of name: String, under path: String) -> String {
		path.isEmpty ? name : path + "/" + name
	}
	
	private func isSystemProbe(_ path: String) -> Bool {
		guard let name = path.split(separator: "/").last.map(String.init) else { return false }
		return Self.systemProbeNames.contains(name) || name.hasPrefix("._")
	}
	
	private func libraryType(forGroup groupName: String) -> LibraryType? {
		switch groupName {
		case "My Libraries":       return .mine
		case "Shared with me":     return .shared
		case "Shared with groups": return .group
		default:                   return nil
		}
	}
	
	private func finishLoading(_ path: String) {
		lock.lock()
		loading.remove(path)
		lock.unlock()
	}
	
	//MARK: - Private helper functions: Populating directory and file attributes
	private func dirAttrs() -> [AnyHashable: Any]{
		var attrs: [AnyHashable: Any] = [:]
		attrs[FileAttributeKey.type] = FileAttributeType.typeDirectory
		attrs[FileAttributeKey.modificationDate] = Date()
		attrs[FileAttributeKey.posixPermissions] = NSNumber(value: 0o755)
		attrs[FileAttributeKey.size] = NSNumber(value: 0)
		return attrs
	}
	
	private func fileAttrs(of entry: DirInfo) -> [AnyHashable: Any]{
		var attrs: [AnyHashable: Any] = [:]
		attrs[FileAttributeKey.type] = FileAttributeType.typeRegular
		attrs[FileAttributeKey.posixPermissions] = NSNumber(value: 0o644)
		attrs[FileAttributeKey.size] = NSNumber(value: entry.size ?? 0)
		attrs[FileAttributeKey.modificationDate] = Date(timeIntervalSince1970: TimeInterval(entry.mtime ?? 0))
		return attrs
	}
	
	//MARK: - Storing libraries, entries
	private func storeLibraries (_ libraries: LibraryList, underGroup groupName: String) {
		var repoNames: [String] = []
		// dirCache["My Libraries"] → ["PrivateLib", "Shared", "FileSecureVault", ...]
		// repoNames is for subdirectories, like ["PrivateLib", "Shared", "FileSecureVault", ...]

		lock.lock()
		for library in libraries {
			let repoName = library.name
			repoNames.append(repoName)
			
			let entryPath = fullPath(of: repoName, under: groupName)
			repoIndex[entryPath] = library.id
			
			// Directories attribute list under the repo folder
			entryCache[entryPath] = DirInfo(type: "dir",
											name: repoName,
											id: library.id,
											size: library.size,
											mtime: library.mtime,
											permission: library.permission)
		}
		// Directories list under the repo folder
		dirCache[groupName] = repoNames
		lock.unlock()
		
		try? volume?.invalidateItem(atPath: groupName)
	}
	
	private func storeEntries (_ entries: [DirInfo], at path: String) {
		var entryNames: [String] = []
		
		lock.lock()
		for entry in entries {
			entryNames.append(entry.name)
			entryCache[fullPath(of: entry.name, under: path)] = entry
		}
		dirCache[path] = entryNames
		lock.unlock()
		
		try? volume?.invalidateItem(atPath: path)
	}
	
	// MARK: - Retriving repo UUID from cache for network fetching
	private func resolveRepository (for path: String) -> DirectoryTarget?{
		let components = path.split(separator: "/").map(String.init)
		// Split path into [String]
		guard components.count >= 2 else { return nil }
		// Must have more than 2 elements to be enough for fecthing directories
		// under the repository
		// e.g. My Libraries/PrivateLib
		
		let repositoryPath = components.prefix(2).joined(separator: "/")
		
		lock.lock()
		let repositoryID = repoIndex[repositoryPath]
		lock.unlock()
		
		guard let repositoryID else { return nil }
		
		let innerPath = "/" + components.dropFirst(2).joined(separator: "/")
		
		return DirectoryTarget(repositoryID: repositoryID, innerPath: innerPath)
	}
	
	//MARK: - Schedule a fetch
	private func scheduleFetch(_ path: String) {
		let credential = SessionStore.shared.token ?? ""
		
		if let libraryType = libraryType(forGroup: path) {
			NetworkAPI.ListLibraries(for: libraryType, credential: credential) { [weak self] result in
				guard let self else { return }
				defer { self.finishLoading(path) }

				switch result {
				case .success(let libraries):
					self.storeLibraries(libraries, underGroup: path)
				case .failure(let error):
					NSLog("[DriveSea] listLibraries %@ failed: %@", path, String(describing: error))
					// TODO: Move log info into i18n file
				}
			}
			return
		}
//		NSLog("%@ -> %@", path, String(describing: libraryType(forGroup: path)))
		
		guard let target = resolveRepository(for: path) else {
			NSLog("[DriveSea] cannot resolve repository for %@", path)
			finishLoading(path)
			return
		}
		
		NetworkAPI.ListDirs(for: target.repositoryID, path: target.innerPath, credential: credential) { [weak self] result in
			guard let self else { return }
			defer { self.finishLoading(path) }
			
			switch result {
			case .success(let entries):
				self.storeEntries(entries, at: path)
			case.failure(let error):
				NSLog("[DriveSea] listDirectories %@ failed: %@", path, String(describing: error))
			}
		}
	}
	
	// MARK: - Overriding FS operations
	
	override func attributesOfItem(atPath path: String!, userData: Any!) throws -> [AnyHashable: Any] {
		let path = normalizeKey(path)
		if isSystemProbe(path) { throw NSError(posixErrorCode: ENOENT) }

		if path.isEmpty || ["My Libraries", "Shared with me", "Shared with groups"].contains(path) {
			return dirAttrs()
		}

		lock.lock()
		let entry = entryCache[path]
		lock.unlock()

		guard let entry else { 
			let parent = (path as NSString).deletingLastPathComponent
			guard !parent.isEmpty else { throw NSError(posixErrorCode: ENOENT) }
			
			lock.lock()
			let shouldFetch = !loading.contains(parent)
			if shouldFetch { loading.insert(parent) }
			lock.unlock()
			if shouldFetch { scheduleFetch(parent) }
			throw NSError(posixErrorCode: ENOENT)
		}

		return entry.type == "dir" ? dirAttrs() : fileAttrs(of: entry)
	}

	override func contentsOfDirectory(atPath path: String!) throws -> [Any] {
		let path = normalizeKey(path)

		// MARK: For ROOT
		if path.isEmpty {
			return ["My Libraries", "Shared with me", "Shared with groups"]
		}

		// MARK: For Other directories
		// Critical Section //
		lock.lock()
		
		if let names = dirCache[path] { lock.unlock(); return names }
		// STEP1: Is there is a cache hit?
		// A: YES, CAN UNWRAP
		// If we can unwrap, it is a **Cache Hit**, return and unlock
		
		// B: NO, CANNOT UNWRAP
		// NO HIT, CALL THE FETCH, GO STEP2
		let busy = loading.contains(path)
		// STEP2: Is the path is under loading?
		if !busy { loading.insert(path) }
		// STEP3: If no, add this path to loading
		
		lock.unlock()
		// Critical Section //

		// Cache Miss
		if !busy { scheduleFetch(path) }
		return []
	}

	override func attributesOfFileSystem(forPath path: String!) throws -> [AnyHashable: Any] {
		var attrs: [AnyHashable: Any] = [:]
		attrs[FileAttributeKey.systemSize] = NSNumber(value: 1 << 30)       // 1 GB 占位
		attrs[FileAttributeKey.systemFreeSize] = NSNumber(value: 1 << 30)
		attrs[FileAttributeKey(rawValue: kGMUserFileSystemVolumeNameKey)] = "DriveSea"
		return attrs
	}
}
