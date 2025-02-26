//
//  ImageCacheTests.swift
//  RecipeFinder
//
//  Created by Juanito on 2/25/25.
//

import XCTest
import CryptoKit
@testable import Recipe_Finder

final class ImageCacheTests: XCTestCase {
	private var mockSession: MockURLSession!
	private var imageCache: ImageCache!
	private var testURL: URL!
	private var testCacheDirectory: URL!

	override func setUp() {
		super.setUp()
		mockSession = MockURLSession()
		testCacheDirectory = FileManager
			.default
			.temporaryDirectory
			.appendingPathComponent(
				"TestCache",
				isDirectory: true
			)

		do {
			try FileManager
				.default
				.createDirectory(
					at: testCacheDirectory,
					withIntermediateDirectories: true,
					attributes: nil
				)
		} catch {
			fatalError("Failed to create test cache directory: \(error)")
		}
		imageCache = ImageCache(
			session: mockSession,
			cacheDirectory: testCacheDirectory
		)
		imageCache.clearCache()
		testURL = URL(string: "https://mockapi.com/test-image.png")!
	}

	override func tearDown() {
		super.tearDown()
	}

	func test_loadImage_fromNetwork_success() async throws {
		let response = HTTPURLResponse(
			url: testURL,
			statusCode: 200,
			httpVersion: nil,
			headerFields: nil
		)
		mockSession.mockResponse = (MockData.validImageData, response, nil)

		let image = try await imageCache.loadImage(from: testURL)

		XCTAssertNotNil(image)
		XCTAssertEqual(
			imageHash(
				image!
			),
			imageHash(
				UIImage(
					data: MockData.validImageData
				)!
			)
		)
	}

	func test_loadImage_fromCache_success() async throws {
		let localURL = ImageCache.fileURL(
			for: testURL,
			using: testCacheDirectory!
		)
		try MockData.validImageData.write(to: localURL)

		let image = try await imageCache.loadImage(from: testURL)

		XCTAssertNotNil(image)
		XCTAssertEqual(
			imageHash(
				image!
			),
			imageHash(
				UIImage(
					data: MockData.validImageData
				)!
			)
		)
	}
	
	func test_loadImage_networkFailure_returnsNil() async throws {
		let url = URL(string: "https://mockapi.com/test-image.png")!
		mockSession.mockResponse = (nil, nil, URLError(.notConnectedToInternet))

		let image = try await imageCache.loadImage(from: url)
		XCTAssertNil(image)
	}

	func test_loadImage_networkFailure_noCachedImage_returnsNil() async throws {
		mockSession.mockResponse = (
			nil,
			nil,
			URLError(.unknown)
		)

		let image = try await imageCache.loadImage(from: testURL)
		XCTAssertNil(image)
	}

	func test_loadImage_corruptData_returnsNil() async throws {
		let response = HTTPURLResponse(
			url: testURL,
			statusCode: 200,
			httpVersion: nil,
			headerFields: nil
		)
		mockSession.mockResponse = (MockData.invalidImageData, response, nil)

		let image = try await imageCache.loadImage(from: testURL)
		XCTAssertNil(image)
	}
	
	private func imageHash(_ image: UIImage) -> String? {
		guard let data = image.pngData() else { return nil }
		let hash = SHA256.hash(data: data)
		return hash.map { String(format: "%02x", $0) }.joined()
	}
}
