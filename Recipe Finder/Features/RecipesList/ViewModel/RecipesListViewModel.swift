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
	
	enum RecipesListState: Equatable {
		case loading
		case error(Error)
		case empty
		case success([Recipe])

		static func == (lhs: RecipesListState, rhs: RecipesListState) -> Bool {
			switch (lhs, rhs) {
			case (.loading, .loading),
				 (.empty, .empty):
				return true
			case let (.success(lhsRecipes), .success(rhsRecipes)):
				return lhsRecipes == rhsRecipes
			case let (.error(lhsError), .error(rhsError)):
				return lhsError.localizedDescription == rhsError.localizedDescription
			default:
				return false
			}
		}
	}

	let viewData = RecipesListViewData()
	@Published var state: RecipesListState = .loading
	@Published var shownRecipes: [Recipe] = []
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
		searchQuery = ""

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
			self.shownRecipes = searchQuery
				.isEmpty ? recipes : recipes.filter { recipe in
					recipe.name.localizedCaseInsensitiveContains(searchQuery) ||
					recipe.cuisine.localizedCaseInsensitiveContains(searchQuery)
			}
			state = self.shownRecipes.isEmpty ? .empty : .success(self.shownRecipes)
		} else {
			shownRecipes = []
		}
	}
}
