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
			.responseDecodable(of: AuthResponse.self) { [weak self] response in
				guard let self = self else {
					return
				}
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
	
	private func HandleNetConnectError(_ error: AFError) -> NetworkRequestResult {
		// First, handle specific HTTP response codes
		if let responseCode = error.responseCode {
			let userInfo: [String: String]
			switch responseCode {
			case 400:
				userInfo = [NSLocalizedDescriptionKey: "坏请求，坏！检查用户名和密码！（HTTP \(responseCode)）"]
			case 401:
				userInfo = [NSLocalizedDescriptionKey: "未授权喵～（HTTP \(responseCode)）"]
			default:
				userInfo = [NSLocalizedDescriptionKey: "HTTP错误码：\(responseCode)"]
			}
			let currentError = NSError(domain: "com.drivesea.network", code: responseCode, userInfo: userInfo)
			return .failure(currentError)
		}

		// Handle underlying system-level errors
		if let underlyingError = error.underlyingError {
			let nserror = underlyingError as NSError
			let code = nserror.code
			var userInfo = nserror.userInfo
			
			switch code {
			case NSURLErrorNotConnectedToInternet:
				userInfo[NSLocalizedDescriptionKey] = "无法连接到互联网喵～"
			case NSURLErrorTimedOut:
				userInfo[NSLocalizedDescriptionKey] = "连接超时喵～"
			case NSURLErrorInternationalRoamingOff:
				userInfo[NSLocalizedDescriptionKey] = "主人还没打开国际漫游喵～"
			case NSURLErrorDataNotAllowed:
				userInfo[NSLocalizedDescriptionKey] = "主人还没允许我使用数据流量喵～"
			case NSURLErrorCannotFindHost:
				userInfo[NSLocalizedDescriptionKey] = "无法找到服务器喵～"
			case NSURLErrorCannotConnectToHost:
				userInfo[NSLocalizedDescriptionKey] = "无法连接到服务器喵～"
			case NSURLErrorNetworkConnectionLost:
				userInfo[NSLocalizedDescriptionKey] = "连接丢失喵～"
			default:
				userInfo[NSLocalizedDescriptionKey] = "未知错误喵～（系统错误代码：NSError \(code)）"
			}
			let currentError = NSError(domain: nserror.domain, code: code, userInfo: userInfo)
			return .failure(currentError)
		}

		// Fallback for any other AFError
		return .failure(error)
	}
}
