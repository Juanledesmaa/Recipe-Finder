//
//  AppConfigurationTests.swift
//  My-Recipes-PrivateTests
//
//  Created by Juanito on 2/24/25.
//

import XCTest
@testable import My_Recipes_Private

final class AppConfigurationTests: XCTestCase {

	func test_baseURL_ReturnsCorrectValue() {
		let mockInfo: [String: Any] = ["BaseURL": "https://mockingapi.io"]
		let mockBundle = MockBundle(mockInfo: mockInfo)
		let appConfiguration = AppConfiguration(bundle: mockBundle)
		
		XCTAssertEqual(appConfiguration.baseUrl, "https://mockingapi.io")
	}
}
