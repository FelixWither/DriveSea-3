//
//  LoginViewModel.swift
//  DriveSea 3
//
//  Created by FelixWither on 2025/1/4.
//

import Foundation
import Alamofire
import Combine

class LoginViewModel: ObservableObject {
	@Published var username: String = ""
	@Published var password: String = ""
	@Published var loginStatus: String = ""

	func login() {
		// Validate input
		guard !username.isEmpty, !password.isEmpty else {
			self.loginStatus = NSLocalizedString("Login_Failed_Input_Empty", comment: "")
			return
		}
		
		// Create the User model with the username and password
		let user = User(username: username, password: password)

		// Call the login method of LoginService
		NetworkAPI.Login(user: user) { result in
			switch result {
			case .success(let authResponse):
				self.loginStatus = String(format: NSLocalizedString("Login_Success_Message", comment: ""),
										  NSLocalizedString("Login_Success", comment: ""),
										  "Token: \(authResponse.token)")
				// Handle the token here
			case .failure(let error):
				self.loginStatus = String(
					format: NSLocalizedString("Login_Failed_Error_Message", comment: ""),
							 NSLocalizedString("Login_Failed", comment: ""),
							 NSLocalizedString("Error", comment: ""),
							 error.localizedDescription)
			}
		}
	}
}
