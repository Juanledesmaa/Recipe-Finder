//
//  RecipesListRepositoryImplementation.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import Foundation

final class RecipesListRepositoryImplementation: RecipesListRepository {
	
	private let dataSource: RecipesListDataSource
	
	init(dataSource: RecipesListDataSource) {
		self.dataSource = dataSource
	}

	func fetchRecipes() async throws -> RecipesList {
		return try await dataSource.fetchRecipes()
	}
}
