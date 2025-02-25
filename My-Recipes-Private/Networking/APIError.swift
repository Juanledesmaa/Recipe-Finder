//
//  APIError.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import Foundation

enum APIError: Error {
	case invalidResponse
	case clientError(statusCode: Int, data: Data)
	case serverError(statusCode: Int)
	case decodingFailed(Error)
	case unexpectedStatusCode(Int)
}
