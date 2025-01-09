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
				ParseData(data) { parsedResult in
					DispatchQueue.main.async {
						completion(parsedResult)
					}
				}
			case let .failure(error):
				DispatchQueue.main.async {
					completion(.failure(error))
				}
			}
		}
	}
	
	static func ListLibraries(for libType: LibraryType, credential: String, 
							  completion: @escaping (Result<LibraryList, Error>) -> Void) {
		NetworkManager.shared.listLibraries(for: libType, credential: credential) { result in
			switch result{
			case let .success(data):
				ParseData(data) { parsedResult in
					DispatchQueue.main.async {
						completion(parsedResult)
					}
				}
			case let .failure(error):
				DispatchQueue.main.async {
					completion(.failure(error))
				}
			}
		}
	}
	
	
	private static func ParseData <T: Decodable>(_ data: Data, completion: @escaping (Result<T, Error>) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async {
			do {
				let decodedData = try JSONDecoder().decode(T.self, from: data)
				completion(.success(decodedData))
			} catch {
				let parseError = NSError(
					domain: "NetworkAPIError",
					code: 0,
					userInfo: [NSLocalizedDescriptionKey: "无法解析数据喵: \(error.localizedDescription)"]
				)
				completion(.failure(parseError))
			}
		}
	}
}
