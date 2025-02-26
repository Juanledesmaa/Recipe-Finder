//
//  ApiErrorTests.swift
//  RecipeFinder
//
//  Created by Juanito on 2/26/25.
//

import XCTest
@testable import Recipe_Finder

final class APIErrorTests: XCTestCase {
	
	func test_invalidResponse_equality() {
		XCTAssertEqual(APIError.invalidResponse, APIError.invalidResponse)
	}
	
	func test_clientError_equality() {
		let error1 = APIError.clientError(
			statusCode: 400,
			data: Data(
				[0x01, 0x02]
			)
		)
		let error2 = APIError.clientError(
			statusCode: 400,
			data: Data(
				[0x03, 0x04]
			)
		)
		
		XCTAssertEqual(error1, error2)
	}
	
	func test_serverError_equality() {
		XCTAssertEqual(
			APIError.serverError(
				statusCode: 500
			),
			APIError.serverError(
				statusCode: 500
			)
		)
	}
	
	func test_unexpectedStatusCode_equality() {
		XCTAssertEqual(
			APIError.unexpectedStatusCode(418),
			APIError.unexpectedStatusCode(418)
		)
	}
	
	func test_decodingFailed_equality() {
		let error1 = APIError.decodingFailed(NSError(domain: "test", code: 1))
		let error2 = APIError.decodingFailed(NSError(domain: "test", code: 2))
		
		XCTAssertEqual(error1, error2)
	}
}
