//
//  NetworkClient.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import Foundation

final class NetworkClient: NetworkClientProtocol {
	
	private static let sharedSession = URLSession.shared
	private let session: URLSessionProtocol
	
	init(session: URLSessionProtocol = sharedSession) {
		self.session = session
	}

	func request<T: Decodable>(
		url: URL,
		method: HTTPMethod = .get
	) async throws -> T {
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		
		let (data, response) = try await session.data(for: request)
		
		guard let httpResponse = response as? HTTPURLResponse else {
			throw APIError.invalidResponse
		}
		
		switch httpResponse.statusCode {
			case 200...299:
				do {
					let jsonDecoder = JSONDecoder()
					jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
					return try jsonDecoder.decode(T.self, from: data)
				} catch {
					let responseString = String(
						data: data,
						encoding: .utf8
					) ?? "Unreadable Data"
					print("Decoding Failed for URL: \(url) | Response: \(responseString)")
					throw APIError.decodingFailed(error)
				}
			case 400...499:
				throw APIError.clientError(
					statusCode: httpResponse.statusCode,
					data: data
				)
			case 500...599:
				throw APIError.serverError(statusCode: httpResponse.statusCode)
			default:
				throw APIError.unexpectedStatusCode(httpResponse.statusCode)
		}
	}
}
