//
//  RecipesListAPIConfiguration.swift
//  RecipeFinder
//
//  Created by Juanito on 2/25/25.
//

import XCTest
@testable import Recipe_Finder

final class RecipesListAPIConfigurationTests: XCTestCase {
	private var mockConfig = MockConfiguration()

	override func setUp() {
		super.setUp()
		UserDefaults.standard.removeObject(forKey: "selectedAPIMode")
	}

	func test_makeRecipesListURL_withoutAnyDebugConfiguration_returnsCorrectDefaultURL() {
		let apiConfig = RecipesListAPIConfiguration(configuration: mockConfig)
		let url = apiConfig.makeRecipesListURL()
		XCTAssertEqual(url?.absoluteString, "https://mockapi.com/recipes.json")
	}

	#if DEBUG
	func test_makeRecipesListURL_debugConfig_withMalformedSelectedMode_makeRecipesListURL_returnsCorrectURL() {
		let debugConfig = RecipesListAPIConfiguration.DebugAPIConfig()
		debugConfig.selectedMode = .malformed
		let apiConfig = RecipesListAPIConfiguration(configuration: mockConfig)
		let url = apiConfig.makeRecipesListURL()
		XCTAssertEqual(
			url?.absoluteString,
			"https://mockapi.com/recipes-malformed.json"
		)
	}

	func test_makeRecipesListURL_debugConfig_withEmptySelectedMode_makeRecipesListURL_returnsCorrectURL() {
		let debugConfig = RecipesListAPIConfiguration.DebugAPIConfig()
		debugConfig.selectedMode = .empty
		let reloadedConfig = RecipesListAPIConfiguration.DebugAPIConfig()
		XCTAssertEqual(reloadedConfig.selectedMode, .empty)
	}
	
	func test_makeRecipesListURL_debugConfig_withFullSelectedMode_makeRecipesListURL_returnsCorrectURL() {
		let debugConfig = RecipesListAPIConfiguration.DebugAPIConfig()
		debugConfig.selectedMode = .full
		let reloadedConfig = RecipesListAPIConfiguration.DebugAPIConfig()
		XCTAssertEqual(reloadedConfig.selectedMode, .full)
	}
	#endif
}
