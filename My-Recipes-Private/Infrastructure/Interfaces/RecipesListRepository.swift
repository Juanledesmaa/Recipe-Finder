//
//  RecipesListRepository.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import Foundation

protocol RecipesListRepository {
	func fetchRecipes() async throws -> RecipesList
}
