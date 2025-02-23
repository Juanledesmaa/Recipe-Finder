//
//  RecipesListViewModel.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import Foundation

@MainActor
final class RecipesListViewModel: ObservableObject {
	@Published var recipesList: RecipesList?
	@Published var isLoading: Bool = false
	@Published var error: Error?
	@Published var searchQuery: String = ""
	
	var filteredRecipes: [Recipe] {
		guard let recipes = recipesList?.recipes else { return [] }

		return searchQuery.isEmpty ? recipes : recipes.filter { recipe in
			recipe.name.localizedCaseInsensitiveContains(searchQuery) ||
			recipe.cuisine.localizedCaseInsensitiveContains(searchQuery)
			
		}
	}

	private let fetchRecipesListUseCase: FetchRecipesListUseCase
	
	init(fetchRecipesListUseCase: FetchRecipesListUseCase) {
		self.fetchRecipesListUseCase = fetchRecipesListUseCase
	}
	
	func fetchRecipesList() async {
		isLoading = true
		error = nil
		defer { isLoading = false }

		do {
			let result = try await fetchRecipesListUseCase.execute()
			recipesList = result
		} catch {
			self.error = error
		}
	}
}
