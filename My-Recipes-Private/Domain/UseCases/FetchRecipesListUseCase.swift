//
//  FetchRecipesListUseCase.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import Foundation

final class FetchRecipesListUseCase {

	private let repository: RecipesListRepository

	init(repository: RecipesListRepository) {
		self.repository = repository
	}

	func execute() async throws -> RecipesList {
		return try await repository.fetchRecipes()
	}
}
