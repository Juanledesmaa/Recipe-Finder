//
//  APIClient.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import Foundation

final class APIClient: APIClientProtocol {
	
	private let session: URLSession
	
	init(session: URLSession = .shared) {
		self.session = session
	}

	func request<T: Decodable>(url: URL, method: HTTPMethod) async throws -> T {
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
