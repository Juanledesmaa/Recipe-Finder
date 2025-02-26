//
//  NetworkClientTests.swift
//  RecipeFinder
//
//  Created by Juanito on 2/25/25.
//

import XCTest
@testable import Recipe_Finder

final class NetworkClientTests: XCTestCase {
	private var mockSession: MockURLSession!
	private var networkClient: NetworkClient!

	override func setUp() {
		super.setUp()
		mockSession = MockURLSession()
		networkClient = NetworkClient(session: mockSession)
	}

	override func tearDown() {
		mockSession = nil
		networkClient = nil
		super.tearDown()
	}

	func test_request_success_returnsCorrectResult() async throws {
		let mockJson = MockData.recipesListJSON
		
		let url = URL(string: "https://mockapi.com/")!
		let response = HTTPURLResponse(
			url: url,
			statusCode: 200,
			httpVersion: nil,
			headerFields: nil
		)

		mockSession.mockResponse = (mockJson, response, nil)

		let result: RecipesList = try await networkClient.request(url: url)

		XCTAssertEqual(result.recipes.first?.uuid, "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
		XCTAssertEqual(result.recipes.first?.name, "Apam Balik")
		XCTAssertEqual(result.recipes.first?.cuisine, "Malaysian")
	}

	func test_request_invalidResponse_returnsInvalidResponse() async {
		let url = URL(string: "https://mockapi.com/recipe")!
		mockSession.mockResponse = (nil, nil, nil)

		do {
			let _ : RecipesList = try await networkClient.request(url: url)
			XCTFail("Expected APIError.invalidResponse but got success")
		} catch let error as APIError {
			XCTAssertEqual(error, .invalidResponse)
		} catch {
			XCTFail("Unexpected error: \(error)")
		}
	}

	func test_request_clientError_returnsCorrectStatusCode() async {
		let url = URL(string: "https://mockapi.com/")!
		let response = HTTPURLResponse(
			url: url, statusCode: 404,
			httpVersion: nil,
			headerFields: nil
		)
		mockSession.mockResponse = (Data(), response, nil)

		do {
			let _ : RecipesList = try await networkClient.request(url: url)
			XCTFail("Expected APIError.clientError but got success")
		} catch let APIError.clientError(statusCode, _) {
			XCTAssertEqual(statusCode, 404)
		} catch {
			XCTFail("Unexpected error: \(error)")
		}
	}

	func test_request_serverError_returnsCorrectStatusCode() async {
		let url = URL(string: "https://mockapi.com/")!
		let response = HTTPURLResponse(
			url: url,
			statusCode: 500,
			httpVersion: nil,
			headerFields: nil
		)
		mockSession.mockResponse = (Data(), response, nil)

		do {
			let _ : RecipesList = try await networkClient.request(url: url)
			XCTFail("Expected APIError.serverError but got success")
		} catch let APIError.serverError(statusCode) {
			XCTAssertEqual(statusCode, 500)
		} catch {
			XCTFail("Unexpected error: \(error)")
		}
	}

	func test_request_decodingFailure_returnsDecodingError() async {
		let invalidJson = "invalid json".data(using: .utf8)!
		let url = URL(string: "https://mockapi.com/recipe")!
		let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

		mockSession.mockResponse = (invalidJson, response, nil)

		do {
			let _ : RecipesList = try await networkClient.request(url: url)
			XCTFail("Expected APIError.decodingFailed but got success")
		} catch let APIError.decodingFailed(decodingError) {
			XCTAssertNotNil(decodingError)
		} catch {
			XCTFail("Unexpected error: \(error)")
		}
	}
	
	func test_request_withUnreadableData_decodingFailure_returnsDecodingError() async {
		let invalidData = Data([0xFF, 0xD8, 0xFF])
		let url = URL(string: "https://mockapi.com/recipe")!
		let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

		mockSession.mockResponse = (invalidData, response, nil)

		do {
			let _ : RecipesList = try await networkClient.request(url: url)
			XCTFail("Expected APIError.decodingFailed but got success")
		} catch let APIError.decodingFailed(decodingError) {
			XCTAssertNotNil(decodingError)
		} catch {
			XCTFail("Unexpected error: \(error)")
		}
	}
	
	func test_request_unknowStatusCode_returnsunexpectedStatusCodeError() async {
		let invalidJson = "invalid json".data(using: .utf8)!
		let url = URL(string: "https://mockapi.com/")!
		let response = HTTPURLResponse(
			url: url,
			statusCode: 1927,
			httpVersion: nil,
			headerFields: nil
		)

		mockSession.mockResponse = (invalidJson, response, nil)

		do {
			let _ : RecipesList = try await networkClient.request(url: url)
			XCTFail("Expected APIError.UnexpectedStatusCode but got success")
		} catch let APIError.unexpectedStatusCode(error) {
			XCTAssertNotNil(error)
		} catch {
			XCTFail("Unexpected error: \(error)")
		}
	}
}

