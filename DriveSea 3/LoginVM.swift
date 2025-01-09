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
	var token: String?

	func login() {
		// Validate input
		guard !username.isEmpty, !password.isEmpty else {
			self.loginStatus = NSLocalizedString("Login_Failed_Input_Empty", comment: "")
			return
		}
		
		// Create the User model with the username and password
		let user = User(username: username, password: password)

		// Call the login method of LoginService
		NetworkAPI.Login(user: user) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let authResponse):
				self.token = authResponse.token
				// Proceed with the next API call to fetch libraries
				guard let token = token else {
					self.loginStatus = NSLocalizedString("Login_Failed_No_Token", comment: "")
					return
				}
				self.fetchLibraries(for: .all, credential: token)
			case .failure(let error):
				displayLoginError(error)
			}
		}
	}

	private func fetchLibraries(for libType: LibraryType, credential: String) {
		// Use the token to fetch libraries
		NetworkAPI.ListLibraries(for: libType, credential: credential) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let libList):
				self.loginStatus = String(format: NSLocalizedString("Login_Success_Message", comment: ""),
										   NSLocalizedString("Login_Success", comment: ""),
										  "Libraries: \(libList.count)")
			case .failure(let error):
				displayLoginError(error)
			}
		}
	}
	
	private func displayLoginError(_ error: Error) {
		self.loginStatus = String(
			format: NSLocalizedString("Login_Failed_Error_Message", comment: ""),
			NSLocalizedString("Login_Failed", comment: ""),
			NSLocalizedString("Error", comment: ""),
			error.localizedDescription)
	}
}
