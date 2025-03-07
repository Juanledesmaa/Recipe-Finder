//
//  RecipesListViewModel.swift
//  RecipeFinder
//
//  Created by Juanito on 2/25/25.
//

import XCTest
@testable import Recipe_Finder

final class RecipesListViewModelTests: XCTestCase {
	private var viewModel: RecipesListViewModel!
	private var mockDataSource: MockRecipesListDataSource!

	@MainActor
	override func setUp() {
		super.setUp()
		mockDataSource = MockRecipesListDataSource()
		viewModel = RecipesListViewModel(recipesListDataSource: mockDataSource)
	}

	@MainActor
	func test_fetchRecipes_success() async {
		let recipes = [
			Recipe(
				uuid: "mock-id",
				name: "Arepas",
				cuisine: "Venezuelan",
				photoUrlLarge: nil,
				photoUrlSmall: nil,
				sourceUrl: nil,
				youtubeUrl: nil
			)
		]
		mockDataSource.mockResponse = .success(recipes)

		await viewModel.fetchRecipesList()

		guard case .success = viewModel.state else {
			XCTFail("State should be success")
			return
		}
		XCTAssertEqual(viewModel.shownRecipes, recipes)
	}

	@MainActor
	func test_fetchRecipes_empty() async {
		mockDataSource.mockResponse = .success([])
		await viewModel.fetchRecipesList()
		guard case .empty = viewModel.state else {
			XCTFail("State should be empty")
			return
		}
		XCTAssertTrue(viewModel.shownRecipes.isEmpty)
	}

	@MainActor
	func test_fetchRecipes_failure() async {
		enum MockError: Error { case fetchFailed }
		mockDataSource.mockResponse = .failure(MockError.fetchFailed)
		await viewModel.fetchRecipesList()
		guard case .error(let error) = viewModel.state else {
			XCTFail("State should be error")
			return
		}
		XCTAssertTrue(error is MockError)
		XCTAssertTrue(viewModel.shownRecipes.isEmpty)
	}
	
	@MainActor
	func test_searchQuery_filtersWithNoMatch_returnsEmptyShowRecipes() async {
		let recipes = [
			Recipe(
				uuid: "mock-id",
				name: "Arepas",
				cuisine: "Venezuelan",
				photoUrlLarge: nil,
				photoUrlSmall: nil,
				sourceUrl: nil,
				youtubeUrl: nil
			),
			Recipe(
				uuid: "mock-id2",
				name: "Empanadas",
				cuisine: "Argentinian",
				photoUrlLarge: nil,
				photoUrlSmall: nil,
				sourceUrl: nil,
				youtubeUrl: nil
			),
			Recipe(
				uuid: "mock-id3",
				name: "Asado",
				cuisine: "Argentinian",
				photoUrlLarge: nil,
				photoUrlSmall: nil,
				sourceUrl: nil,
				youtubeUrl: nil
			)
		]
		mockDataSource.mockResponse = .success(recipes)
		await viewModel.fetchRecipesList()

		viewModel.searchQuery = "Bellingham"

		XCTAssertEqual(viewModel.shownRecipes.count, 0)
	}

	@MainActor
	func test_searchQuery_filtersRecipesCorrectlyByCuisine() async {
		let recipes = [
			Recipe(
				uuid: "mock-id",
				name: "Arepas",
				cuisine: "Venezuelan",
				photoUrlLarge: nil,
				photoUrlSmall: nil,
				sourceUrl: nil,
				youtubeUrl: nil
			),
			Recipe(
				uuid: "mock-id2",
				name: "Empanadas",
				cuisine: "Argentinian",
				photoUrlLarge: nil,
				photoUrlSmall: nil,
				sourceUrl: nil,
				youtubeUrl: nil
			),
			Recipe(
				uuid: "mock-id3",
				name: "Asado",
				cuisine: "Argentinian",
				photoUrlLarge: nil,
				photoUrlSmall: nil,
				sourceUrl: nil,
				youtubeUrl: nil
			)
		]
		mockDataSource.mockResponse = .success(recipes)
		await viewModel.fetchRecipesList()

		viewModel.searchQuery = "Argen"

		XCTAssertEqual(viewModel.shownRecipes.count, 2)
		XCTAssertEqual(viewModel.shownRecipes[0].name, "Empanadas")
		XCTAssertEqual(viewModel.shownRecipes[1].name, "Asado")
	}
	
	@MainActor
	func test_searchQuery_filtersRecipesCorrectlyByName() async {
		// Given
		let recipes = [
			Recipe(
				uuid: "mock-id",
				name: "Arepas",
				cuisine: "Venezuelan",
				photoUrlLarge: nil,
				photoUrlSmall: nil,
				sourceUrl: nil,
				youtubeUrl: nil
			),
			Recipe(
				uuid: "mock-id2",
				name: "Empanadas",
				cuisine: "Argentinian",
				photoUrlLarge: nil,
				photoUrlSmall: nil,
				sourceUrl: nil,
				youtubeUrl: nil
			),
			Recipe(
				uuid: "mock-id3",
				name: "Asado",
				cuisine: "Argentinian",
				photoUrlLarge: nil,
				photoUrlSmall: nil,
				sourceUrl: nil,
				youtubeUrl: nil
			)
		]
		mockDataSource.mockResponse = .success(recipes)
		await viewModel.fetchRecipesList()

		viewModel.searchQuery = "Are"

		XCTAssertEqual(viewModel.shownRecipes.count, 1)
		XCTAssertEqual(viewModel.shownRecipes[0].name, "Arepas")
	}
}
