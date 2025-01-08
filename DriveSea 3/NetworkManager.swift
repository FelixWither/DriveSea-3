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

let baseURL = "http://192.168.0.200:8000/api2/"
let getToken = "auth-token/"


class NetworkManager {
	//MARK: - Create Shared Instance
	static let shared = NetworkManager()
	//MARK: - Single(Shared) Instance Only
	private init() {}
	
	@discardableResult
	func login(user: User, completion: @escaping NetworkRequestCompletion) -> DataRequest{
		// Define the API endpoint
		let url = baseURL + getToken
		let parameters = user.toDictionary()
		
		// Perform the POST request
		return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
			.validate() // Automatically checks HTTP response status codes
			.responseDecodable(of: AuthResponse.self) { [weak self] response in
				guard let self = self else { return }
				self.APISuccessCheck(response, completion: completion)
		}
	}
	
	//MARK: - General API success check
	private func APISuccessCheck <T: Decodable>(_ response: DataResponse<T, AFError>, completion: @escaping NetworkRequestCompletion){
		switch response.result{
		case .success(_):
			let data = response.data
			completion(.success(data!))
			
		case let .failure(error): completion(HandleNetConnectError(error))
		}
	}
	
	//MARK: - Return specific network error type with localized description
	private func HandleNetConnectError(_ error: AFError) -> NetworkRequestResult {
		let userInfo: [String: String]
		let domain = "com.drivesea.network"
		let errMsg = NSLocalizedDescriptionKey
		
		// First, handle specific HTTP response codes
		if let responseCode = error.responseCode {
			switch responseCode {
			case 400:
				userInfo = [errMsg: String(format: NSLocalizedString("HTTPBadRequestMsg", comment: ""),
													NSLocalizedString("HTTPBadRequest", comment: ""),
													responseCode)]
			case 401:
				userInfo = [errMsg: String(format: NSLocalizedString("HTTPUnauthorizedMsg", comment: ""),
													NSLocalizedString("HTTPUnauthorized", comment: ""),
													responseCode)]
			default:
				userInfo = [errMsg: String(format: NSLocalizedString("HTTPErrCodeMsg", comment: ""),
													NSLocalizedString("HTTPErrCode", comment:""),
													responseCode)]
			}
			let currentError = NSError(domain: domain, code: responseCode, userInfo: userInfo)
			return .failure(currentError)
		}

		// Handle underlying system-level errors
		if let underlyingError = error.underlyingError {
			let nserror = underlyingError as NSError
			let code = nserror.code
			var userInfo = nserror.userInfo
			
			switch code {
			case NSURLErrorNotConnectedToInternet:
				userInfo[NSLocalizedDescriptionKey] = NSLocalizedString("NotConnectedToInternet", comment: "")
			case NSURLErrorTimedOut:
				userInfo[NSLocalizedDescriptionKey] = NSLocalizedString("ConnectionTimedOut", comment: "")
			case NSURLErrorInternationalRoamingOff:
				userInfo[NSLocalizedDescriptionKey] = NSLocalizedString("InternationalRoamingOff", comment: "")
			case NSURLErrorDataNotAllowed:
				userInfo[NSLocalizedDescriptionKey] = NSLocalizedString("DataNetworkNotAllowed", comment: "")
			case NSURLErrorCannotFindHost:
				userInfo[NSLocalizedDescriptionKey] = NSLocalizedString("CannotFindHost", comment: "")
			case NSURLErrorCannotConnectToHost:
				userInfo[NSLocalizedDescriptionKey] = NSLocalizedString("CannotConnectToHost", comment: "")
			case NSURLErrorNetworkConnectionLost:
				userInfo[NSLocalizedDescriptionKey] = NSLocalizedString("NetworkConnectionLost", comment: "")
			default:
				userInfo[NSLocalizedDescriptionKey] = String(format: NSLocalizedString("OtherNetworkError", comment: ""),
															 NSLocalizedString("UnknownError", comment: ""),
															 NSLocalizedString("SystemErrorCode", comment: ""),
															 code)
			}
			let currentError = NSError(domain: nserror.domain, code: code, userInfo: userInfo)
			return .failure(currentError)
		}

		// Fallback for any other AFError
		return .failure(error)
	}
}
