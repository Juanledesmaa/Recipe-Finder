//
//  APIError.swift
//  RecipeFinder
//
//  Created by Juanito on 2/22/25.
//

import Foundation

enum APIError: Error, Equatable {
	case invalidResponse
	case clientError(statusCode: Int, data: Data)
	case serverError(statusCode: Int)
	case decodingFailed(Error)
	case unexpectedStatusCode(Int)
	
	static func == (lhs: APIError, rhs: APIError) -> Bool {
		switch (lhs, rhs) {
		case (.invalidResponse, .invalidResponse):
			return true
		case let (.clientError(lhsCode, _), .clientError(rhsCode, _)):
			return lhsCode == rhsCode
		case let (.serverError(lhsCode), .serverError(rhsCode)):
			return lhsCode == rhsCode
		case let (
			.unexpectedStatusCode(lhsCode), .unexpectedStatusCode(rhsCode)):
			return lhsCode == rhsCode
		case (.decodingFailed, .decodingFailed):
			return true
		default:
			return false
		}
	}
}
