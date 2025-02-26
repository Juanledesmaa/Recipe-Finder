//
//  RecipeTests.swift
//  RecipeFinder
//
//  Created by Juanito on 2/26/25.
//

import XCTest
@testable import Recipe_Finder

final class RecipeTests: XCTestCase {
	
	func test_decodeRecipe_success() throws {
		let decoder = JSONDecoder()
		let decodedRecipe = try decoder.decode(Recipe.self, from: MockData.singleRecipeJSON)

		XCTAssertEqual(decodedRecipe.uuid, "mock-id")
		XCTAssertEqual(decodedRecipe.name, "Pizza")
		XCTAssertEqual(decodedRecipe.cuisine, "Italian")
		XCTAssertEqual(
			decodedRecipe.photoUrlLarge,
			"https://mockapi.com/large.jpg"
		)
		XCTAssertEqual(
			decodedRecipe.photoUrlSmall,
			"https://mockapi.com/small.jpg"
		)
		XCTAssertEqual(
			decodedRecipe.sourceUrl,
			"https://mockapi.com/recipes/pizza"
		)
		XCTAssertEqual(
			decodedRecipe.youtubeUrl,
			"https://www.youtube.com/watch?v=pizza"
		)
	}

	func test_decodeRecipe_missingOptionalFields() throws {
		let decoder = JSONDecoder()
		let decodedRecipe = try decoder.decode(Recipe.self, from: MockData.singleRecipeJSONMissingFields)

		XCTAssertEqual(decodedRecipe.uuid, "mock-id")
		XCTAssertEqual(decodedRecipe.name, "Pizza")
		XCTAssertEqual(decodedRecipe.cuisine, "Italian")
		XCTAssertNil(decodedRecipe.photoUrlLarge)
		XCTAssertNil(decodedRecipe.photoUrlSmall)
		XCTAssertNil(decodedRecipe.sourceUrl)
		XCTAssertNil(decodedRecipe.youtubeUrl)
	}

	func test_decodeRecipe_invalidJSON_fails() {
		let decoder = JSONDecoder()
		XCTAssertThrowsError(try decoder.decode(Recipe.self, from: MockData.invalidJSON)) { error in
			XCTAssertTrue(error is DecodingError)
		}
	}

	func test_recipeEquatable_equalObjects() {
		let recipe1 = Recipe(
			uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f",
			name: "Apple & Blackberry Crumble",
			cuisine: "British",
			photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
			photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
			sourceUrl: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
			youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
		)

		let recipe2 = Recipe(
			uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f",
			name: "Apple & Blackberry Crumble",
			cuisine: "British",
			photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
			photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
			sourceUrl: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
			youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
		)

		XCTAssertEqual(recipe1, recipe2)
	}

	func test_recipeEquatable_notEqualObjects() {
		let recipe1 = Recipe(
			uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f",
			name: "Apple & Blackberry Crumble",
			cuisine: "British",
			photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
			photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
			sourceUrl: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
			youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
		)

		let recipe2 = Recipe(
			uuid: "123123",
			name: "123124",
			cuisine: "1241241",
			photoUrlLarge: nil,
			photoUrlSmall: nil,
			sourceUrl: nil,
			youtubeUrl: nil
		)

		XCTAssertNotEqual(recipe1, recipe2)
	}
}
