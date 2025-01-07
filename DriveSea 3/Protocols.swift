//
//  Protocols.swift
//  DriveSea 3
//
//  Created by FelixWither on 2025/1/7.
//

import Foundation

protocol JSONCodable: Codable {
	func toDictionary() -> [String: Any]?
}

extension JSONCodable {
	func toDictionary() -> [String: Any]? {
		let encoder = JSONEncoder()
		guard let data = try? encoder.encode(self),
			  let dictionary = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
			return nil
		}
		return dictionary
	}
}
