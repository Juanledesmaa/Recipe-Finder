//
//  RecipesListViewModel.swift
//  RecipeFinder
//
//  Created by Juanito on 2/22/25.
//

import SwiftUI

@MainActor
final class RecipesListViewModel: ObservableObject {
	struct RecipesListViewData {
		let navigationTitle = "Recipes"
		let textFieldPlaceholder = "Search recipes..."
		let progressViewText = "Loading Recipes..."
		let errorImageSize = CGSize(width: 100, height: 100)
		let errorImageName = "alert"
		let errorTitle = "An error occurred while fetching recipes."
		let errorSubtitle = "Please try again later."
		let emptyImageName = "vegetables"
		let emptyRecipesTitle = "No recipes could be found."
	}
	
	enum RecipesListState {
		case loading
		case error(Error)
		case empty
		case success([Recipe])
	}

	let viewData = RecipesListViewData()
	@Published var state: RecipesListState = .loading
	@Published var recipes: [Recipe] = []
	@Published var searchQuery: String = "" {
		didSet {
			filterRecipesIfNeeded()
		}
	}

	private let recipesListDataSource: RecipesListDataSource

	init(recipesListDataSource: RecipesListDataSource) {
		self.recipesListDataSource = recipesListDataSource
	}

	func fetchRecipesList() async {
		state = .loading

		do {
			let result = try await recipesListDataSource.fetchRecipes()
			state = result.recipes.isEmpty ? .empty : .success(result.recipes)
			filterRecipesIfNeeded()
		} catch {
			state = .error(error)
		}
	}
	
	private func filterRecipesIfNeeded() {
		if case .success(let recipes) = state {
			self.recipes = searchQuery
				.isEmpty ? recipes : recipes.filter { recipe in
					recipe.name.localizedCaseInsensitiveContains(searchQuery) ||
					recipe.cuisine.localizedCaseInsensitiveContains(searchQuery)
			}
		} else {
			recipes = []
		}
	}
}
