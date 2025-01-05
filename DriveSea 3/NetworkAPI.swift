//
//  NetworkAPI.swift
//  DriveSea 3
//
//  Created by FelixWither on 2025/1/5.
//

import Foundation

class NetworkAPI{
	static func Login(user: User, completion: @escaping (Result<AuthResponse, Error>) -> Void){
		NetworkManager.shared.login(user: user) { result in
			switch result{
			case let .success(data):
				let parsedResult: Result<AuthResponse,Error> = ParseData(data)
				completion(parsedResult)
			case let .failure(error):
				completion(.failure(error))
			}
		}
	}
	
	
	private static func ParseData <T: Decodable>(_ data: Data) -> Result<T, Error>{
		guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else{
			let error = NSError(domain: "NetworkAPIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "无法解析数据喵"])
			return .failure(error)
		}
		return .success(decodedData)
	}
}
