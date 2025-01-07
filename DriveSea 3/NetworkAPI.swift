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
			switch result {
			case let .success(data):
				ParseData(data) { completion($0) }
			case let .failure(error):
				completion(.failure(error))
			}
		}
	}
	
	
	private static func ParseData <T: Decodable>(_ data: Data, completion: @escaping (Result<T, Error>) -> Void) {
		DispatchQueue.global(qos: .background).async {
			do {
				let decodedData = try JSONDecoder().decode(T.self, from: data)
				DispatchQueue.main.async {
					completion(.success(decodedData))
				}
			} catch {
				let parseError = NSError(
					domain: "NetworkAPIError",
					code: 0,
					userInfo: [NSLocalizedDescriptionKey: "无法解析数据喵: \(error.localizedDescription)"]
				)
				DispatchQueue.main.async {
					completion(.failure(parseError))
				}
			}
		}
	}
}
