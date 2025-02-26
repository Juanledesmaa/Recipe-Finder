//
//  AppConfigurationTests.swift
//  RecipeFinderTests
//
//  Created by Juanito on 2/24/25.
//

import XCTest
@testable import Recipe_Finder

final class AppConfigurationTests: XCTestCase {

	func test_baseURL_whenNoInfoInBundle_ReturnsEmptyString() {
		let mockInfo: [String: Any] = [:]
		let mockBundle = MockBundle(mockInfo: mockInfo)
		let appConfiguration = AppConfiguration(bundle: mockBundle)
		
		// Ensure we are not crashing even if no info is set
		XCTAssertEqual(appConfiguration.baseUrl, "")
	}

	func test_baseURL_ReturnsCorrectValue() {
		let mockInfo: [String: Any] = ["BaseURL": "https://mockingapi.io"]
		let mockBundle = MockBundle(mockInfo: mockInfo)
		let appConfiguration = AppConfiguration(bundle: mockBundle)
		
		XCTAssertEqual(appConfiguration.baseUrl, "https://mockingapi.io")
	}
}
