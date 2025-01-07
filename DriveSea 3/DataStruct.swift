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
