//
//  NetworkManager.swift
//  DriveSea 3
//
//  Created by FelixWither on 2025/1/4.
//

import Foundation
import Alamofire

typealias NetworkRequestResult = Result<Data, Error>
typealias NetworkRequestCompletion = (NetworkRequestResult) -> Void


class NetworkManager {
	//MARK: - Create Shared Instance
	static let shared = NetworkManager()
	//MARK: - Single(Shared) Instance Only
	private init() {}
	
	@discardableResult
	func login(user: User, completion: @escaping NetworkRequestCompletion) -> DataRequest{
		// Define the API endpoint
		let url = "http://192.168.0.200:8000/api2/auth-token/"
		
		// Prepare the payload
		let parameters: [String: String] = [
			"username": user.username,
			"password": user.password
		]
		
		// Perform the POST request
		return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
			.validate() // Automatically checks HTTP response status codes
			.responseDecodable(of: AuthResponse.self) { response in
				self.APISuccessCheck(response, completion: completion)
			}
	}
	
	private func APISuccessCheck(_ response: DataResponse<AuthResponse, AFError>, completion: @escaping NetworkRequestCompletion){
		switch response.result{
		case .success(_):
			let data = response.data
			completion(.success(data!))
			
		case let .failure(error): completion(HandleNetConnectError(error))
		}
	}
	
	private func HandleNetConnectError(_ error: AFError) -> NetworkRequestResult{
		if let underlyingError =
			error.underlyingError{
			let nserror = underlyingError as NSError
			let code = nserror.code
			if code == NSURLErrorNotConnectedToInternet ||
				code == NSURLErrorTimedOut ||
				code == NSURLErrorInternationalRoamingOff ||
				code == NSURLErrorDataNotAllowed ||
				code == NSURLErrorCannotFindHost ||
				code == NSURLErrorCannotConnectToHost ||
				code == NSURLErrorNetworkConnectionLost{
				var userInfo = nserror.userInfo
				userInfo[NSLocalizedDescriptionKey] = "网络连接有问题喵～"
				let currentError = NSError(domain: nserror.domain, code: code, userInfo: userInfo)
				return .failure(currentError)
			}
		}
		return .failure(error)
	}
}
