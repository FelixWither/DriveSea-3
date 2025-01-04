//
//  LoginViewModel.swift
//  DriveSea 3
//
//  Created by FelixWither on 2025/1/4.
//

import Foundation
import Alamofire
import Combine
import SwiftUI

class LoginViewModel: ObservableObject {
	@Published var username: String = ""
	@Published var password: String = ""
	@Published var loginStatus: LocalizedStringResource = ""

	func login() {
		// Validate input
		guard !username.isEmpty, !password.isEmpty else {
			self.loginStatus = LocalizedStringResource("Login_Failed_Input_Empty")
			return
		}
		
		// Create the User model with the username and password
		let user = User(username: username, password: password)

		// Call the login method of LoginService
		NetworkAPI.Login(user: user) { result in
			switch result {
			case .success(let authResponse):
				self.loginStatus = "\(LocalizedStringResource("Login_Success")) Token: \(authResponse.token)"
				// Handle the token here
			case .failure(let error):
				self.loginStatus = "\(LocalizedStringResource("Login_Failed")) Error: \(error.localizedDescription)"
			}
		}
	}
}
