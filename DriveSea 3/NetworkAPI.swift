//
//  NetworkAPI.swift
//  DriveSea 3
//
//  Created by FelixWither on 2025/1/5.
//

import Foundation

typealias DecodedResult <T: Decodable> = Result<T, Error>
typealias DecodedResultHandler <T: Decodable> = (DecodedResult<T>) -> Void

class NetworkAPI{
	static func Login(user: User, completion: @escaping (Result<AuthResponse, Error>) -> Void){
		NetworkManager.shared.login(user: user) { result in
			HandleResult(result, completion: completion)
		}
	}
	
	static func ListLibraries(for libType: LibraryType, credential: String, 
							  completion: @escaping (Result<LibraryList, Error>) -> Void) {
		NetworkManager.shared.listLibraries(for: libType, credential: credential) { result in
			HandleResult(result, completion: completion)
		}
	}
	
	private static func HandleResult <T: Decodable>(_ result: NetworkRequestResult, completion: @escaping DecodedResultHandler<T>) {
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
