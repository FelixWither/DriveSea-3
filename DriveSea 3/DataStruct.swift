//
//  DataStruct.swift
//  DriveSea 3
//
//  Created by FelixWither on 2025/1/5.
//

import Foundation

struct User: JSONCodable {
	var username: String
	var password: String
}

struct AuthResponse: Codable {
	let token: String
}

struct LibraryInfo: Codable {
	let ownerContactEmail: String
	let ownerName: String
	let owner: String
	let modifierEmail: String
	let modifierContactEmail: String
	let modifierName: String
	let name: String
	let id: String
	let permission: String
	let virtual: Bool?
	let mtime: Int
	let mtimeRelative: String
	let encrypted: Bool
	let version: Int
	let headCommitId: String
	let root: String
	let type: String
	let salt: String
	let sizeFormatted: String
	let size: Int
	let groupName: String?
	let shareType: String?
	let isAdmin: Bool?
	
	enum CodingKeys: String, CodingKey {
		case ownerContactEmail = "owner_contact_email"
		case ownerName = "owner_name"
		case owner
		case modifierEmail = "modifier_email"
		case modifierContactEmail = "modifier_contact_email"
		case modifierName = "modifier_name"
		case name
		case id
		case permission
		case virtual
		case mtime
		case mtimeRelative = "mtime_relative"
		case encrypted
		case version
		case headCommitId = "head_commit_id"
		case root
		case type
		case salt
		case sizeFormatted = "size_formatted"
		case size
		case groupName = "group_name"
		case shareType = "share_type"
		case isAdmin = "is_admin"
	}
}
