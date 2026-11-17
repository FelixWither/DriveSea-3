//
//  SeafFS.swift
//  DriveSea 3
//
//  Created by FelixWither on 2026/11/17.
//

import Foundation

final class SeafFS: NSObject {
	// P0 阶段只实现"能挂"所需的最小面
	override func attributesOfItem(atPath path: String!, userData: Any!) throws -> [AnyHashable: Any] {
		// 根目录给一个目录属性，其他一律 ENOENT —— 先让 Finder 肯进卷
		if path.isEmpty || path == "/" {
			var attrs: [AnyHashable: Any] = [:]
			attrs[FileAttributeKey.type] = FileAttributeType.typeDirectory
			attrs[FileAttributeKey.modificationDate] = Date()
			return attrs
		}
		throw NSError(posixErrorCode: ENOENT)
	}

	override func contentsOfDirectory(atPath path: String!) throws -> [Any] { [] }

	override func attributesOfFileSystem(forPath path: String!) throws -> [AnyHashable: Any] {
		var attrs: [AnyHashable: Any] = [:]
		attrs[FileAttributeKey.systemSize] = NSNumber(value: 1 << 30)       // 1 GB 占位
		attrs[FileAttributeKey.systemFreeSize] = NSNumber(value: 1 << 30)
		attrs[FileAttributeKey(rawValue: kGMUserFileSystemVolumeNameKey)] = "DriveSea"
		return attrs
	}
}
