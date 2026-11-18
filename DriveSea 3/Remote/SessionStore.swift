//
//  SessionStore.swift
//  DriveSea 3
//
//  Created by FelixWither on 2026/11/18.
//

import Foundation

final class SessionStore {
	static let shared = SessionStore()
	var token: String?
}
