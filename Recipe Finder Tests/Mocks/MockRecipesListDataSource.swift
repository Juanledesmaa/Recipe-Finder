//
//  MockRecipesListDataSource.swift
//  RecipeFinder
//
//  Created by Juanito on 2/25/25.
//

@testable import Recipe_Finder

final class MockRecipesListDataSource: RecipesListDataSource {
	enum MockResponse {
		case success([Recipe])
		case failure(Error)
	}

	var mockResponse: MockResponse = .success([])

	func fetchRecipes() async throws -> RecipesList {
		switch mockResponse {
		case .success(let recipes):
			return RecipesList(recipes: recipes)
		case .failure(let error):
			throw error
		}
	}
}
