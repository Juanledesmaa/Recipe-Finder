//
//  MockURLSession.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/25/25.
//

import Foundation
@testable import My_Recipes_Private

final class MockURLSession: URLSessionProtocol {
	var mockResponse: (Data?, URLResponse?, Error?) = (nil, nil, nil)

	func data(for request: URLRequest) async throws -> (Data, URLResponse) {
		if let error = mockResponse.2 {
			throw error
		}
		guard let data = mockResponse.0, let response = mockResponse.1 else {
			throw APIError.invalidResponse
		}
		return (data, response)
	}
}

