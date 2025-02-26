//
//  RemotesRecipesListDataSourceTests.swift
//  RecipeFinder
//
//  Created by Juanito on 2/25/25.
//

import XCTest
@testable import Recipe_Finder

final class RemoteRecipesListDataSourceTests: XCTestCase {
	private var mockNetworkClient: MockNetworkClient!
	private var mockConfig = MockConfiguration()
	private var mockAPIConfiguration: MockRecipesListAPIConfiguration!
	private var dataSource: RemoteRecipesListDataSource!

	override func setUp() {
		super.setUp()
		mockNetworkClient = MockNetworkClient()
		mockAPIConfiguration = MockRecipesListAPIConfiguration(
			configuration: MockConfiguration()
		)
		dataSource = RemoteRecipesListDataSource(
			networkClient: mockNetworkClient,
			apiConfiguration: mockAPIConfiguration
		)
	}

	override func tearDown() {
		mockNetworkClient = nil
		mockAPIConfiguration = nil
		dataSource = nil
		super.tearDown()
	}

	func test_fetchRecipes_success() async throws {
		let mockRecipes = RecipesList(recipes: [
			Recipe(
				uuid: "mock-id",
				name: "Arepas",
				cuisine: "Venezuelan",
				photoUrlLarge: nil,
				photoUrlSmall: nil,
				sourceUrl: nil,
				youtubeUrl: nil
			)
		])
		mockNetworkClient.mockResponse = .success(mockRecipes)
		mockAPIConfiguration.mockURL = URL(
			string: "https://mockapi.com/recipes.json"
		)

		let result = try await dataSource.fetchRecipes()

		XCTAssertEqual(result.recipes.count, 1)
		XCTAssertEqual(result.recipes.first?.name, "Arepas")
	}

	func test_fetchRecipes_invalidURL() async {
		mockAPIConfiguration.mockURL = nil

		do {
			_ = try await dataSource.fetchRecipes()
			XCTFail("Expected an error but got success")
		} catch {
			XCTAssertEqual((error as NSError).code, -1)
			XCTAssertEqual(
				(error as NSError).localizedDescription,
				"Invalid URL"
			)
		}
	}

	func test_fetchRecipes_networkFailure() async {
		mockAPIConfiguration.mockURL = URL(
			string: "https://mockapi.com/recipes.json"
		)
		mockNetworkClient.mockResponse = .failure(
			NSError(domain: "NetworkError",
					code: -1001,
					userInfo: nil
				   )
		)

		do {
			_ = try await dataSource.fetchRecipes()
			XCTFail("Expected an error but got success")
		} catch {
			XCTAssertEqual((error as NSError).domain, "NetworkError")
			XCTAssertEqual((error as NSError).code, -1001)
		}
	}
}
