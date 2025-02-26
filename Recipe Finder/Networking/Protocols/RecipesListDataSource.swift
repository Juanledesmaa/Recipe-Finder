//
//  RecipesListDataSource.swift
//  RecipeFinder
//
//  Created by Juanito on 2/22/25.
//

import Foundation

protocol RecipesListDataSource {
	func fetchRecipes() async throws -> RecipesList
}
