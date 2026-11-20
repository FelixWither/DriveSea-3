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
	
	// MARK: - Private helper functions
	private func normalizeKey(_ path: String?) -> String {
		let p = (path ?? "").trimmingCharacters(in: CharacterSet(charactersIn: "/"))
		// Remove the "/" at the both ends of String
		return p.precomposedStringWithCanonicalMapping
		// Normalize the String, see Wiki
	}
	
	private func scheduleFetch(_ p: String) {
		//TODO: Fill
	}
	
	// MARK: - Overriding FS operations
	
	override func attributesOfItem(atPath path: String!, userData: Any!) throws -> [AnyHashable: Any] {
		// 根目录给一个目录属性，其他一律 ENOENT —— 先让 Finder 肯进卷
		if path.isEmpty || path == "/" {
			var attrs: [AnyHashable: Any] = [:]
			attrs[FileAttributeKey.type] = FileAttributeType.typeDirectory
			attrs[FileAttributeKey.modificationDate] = Date()
			attrs[FileAttributeKey.posixPermissions] = NSNumber(value: 0o755)
			attrs[FileAttributeKey.size] = NSNumber(value: 0)
			return attrs
		}
		throw NSError(posixErrorCode: ENOENT)
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
