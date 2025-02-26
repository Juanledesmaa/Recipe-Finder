//
//  ImageLoaderTests.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/26/25.
//

import XCTest
import SwiftUI
@testable import My_Recipes_Private

final class ImageLoaderTests: XCTestCase {
	private var mockSession: MockURLSession!
	private var mockCache: URLCache!
	private var imageLoader: ImageLoader!
	private var testURL: URL!

	override func setUp() {
		super.setUp()
		mockSession = MockURLSession()
		mockCache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: nil)
		testURL = URL(string: "https://mockapi.com/test-image.png")!
		imageLoader = ImageLoader(url: testURL, urlSession: mockSession, cache: mockCache)
		mockCache.removeAllCachedResponses()
	}

	override func tearDown() {
		mockSession = nil
		mockCache.removeAllCachedResponses()
		imageLoader = nil
		testURL = nil
		super.tearDown()
	}

	func test_loadImage_success() async {
		let expectation = expectation(description: "Waiting for image phase update")

		let response = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)
		mockSession.mockResponse = (MockData.validImageData, response, nil)

		Task {
			await imageLoader.load()
			expectation.fulfill()
		}

		await fulfillment(of: [expectation], timeout: 2.0)

		if case .success(let image) = imageLoader.phase {
			XCTAssertNotNil(image)
		} else {
			XCTFail("Expected success but got error")
		}
	}

	func test_loadImage_fromCache_success() async {
		let expectation = expectation(description: "Waiting for image phase update")

		let request = URLRequest(url: testURL)
		let response = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)
		let cachedResponse = CachedURLResponse(response: response!, data: MockData.validImageData)

		mockCache.storeCachedResponse(cachedResponse, for: request)

		Task {
			await imageLoader.load()
			expectation.fulfill()
		}

		await fulfillment(of: [expectation], timeout: 2.0)

		if case .success(let image) = imageLoader.phase {
			XCTAssertNotNil(image)
		} else {
			XCTFail("Expected success from cache but got error")
		}
	}

	func test_loadImage_invalidURL_returnsFailure() async {
		let expectation = expectation(description: "Waiting for failure due to invalid URL")

		imageLoader = ImageLoader(url: nil, urlSession: mockSession, cache: mockCache)

		Task {
			await imageLoader.load()
			expectation.fulfill()
		}

		await fulfillment(of: [expectation], timeout: 2.0)

		if case .failure(let error) = imageLoader.phase {
			XCTAssertEqual((error as? URLError)?.code, .badURL)
		} else {
			XCTFail("Expected failure due to nil URL")
		}
	}

	func test_loadImage_networkFailure_returnsFailure() async {
		let expectation = expectation(description: "Waiting for failure due to network error")

		mockSession.mockResponse = (nil, nil, URLError(.notConnectedToInternet))

		Task {
			await imageLoader.load()
			expectation.fulfill()
		}

		await fulfillment(of: [expectation], timeout: 2.0)

		if case .failure(let error) = imageLoader.phase {
			XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
		} else {
			XCTFail("Expected failure due to network error")
		}
	}
}
