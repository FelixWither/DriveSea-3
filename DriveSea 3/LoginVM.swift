//
//  LoginVM.swift
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
	
	private var cancellables = Set<AnyCancellable>()
	
	func login() {
		// Define the API endpoint
		let url = "http://192.168.0.200:8000/api2/auth-token/"
		
		// Prepare the payload
		let parameters: [String: String] = [
			"username": username,
			"password": password
		]
		
		// Perform the POST request
		AF.request(url,
				   method: .post,
				   parameters: parameters,
				   encoding: JSONEncoding.default)
			.validate() // Automatically checks HTTP response status codes
			.responseDecodable(of: AuthResponse.self) { response in
				switch response.result {
				case .success(let authResponse):
					DispatchQueue.main.async {
						self.loginStatus = "\(LocalizedStringResource("Login_Success")) Token: \(authResponse.token)"
					}
				case .failure(let error):
					DispatchQueue.main.async {
						self.loginStatus = "\(LocalizedStringResource( "Login_Failed")): \(error.localizedDescription)"
					}
				}
			}
	}
}

// Define the response structure
struct AuthResponse: Decodable {
	let token: String
}
