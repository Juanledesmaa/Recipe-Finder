//
//  RecipesListView.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import SwiftUI

struct RecipesListView: View {
	
	@StateObject private var viewModel: RecipesListViewModel
	
	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible()),
	]
	
	init(viewModel: RecipesListViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}
	
	var body: some View {
		NavigationView {
			content
				.navigationTitle("Recipes")
				.background(Color.appColor.primaryBackground)
		}
		.task {
			await viewModel.fetchRecipesList()
		}
	}

	@ViewBuilder
	private var content: some View {
		VStack {
			TextField("Search recipes...", text: $viewModel.searchQuery)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.padding()

			if viewModel.isLoading {
				ProgressView("Loading Recipes...")
			} else if let error = viewModel.error {
				Text("Error: \(error.localizedDescription)").foregroundColor(.red)
			} else if let _ = viewModel.recipesList {
				ScrollView {
					LazyVGrid(columns: columns, spacing: 16) {
						ForEach(viewModel.filteredRecipes, id: \.uuid) { recipe in
							RecipeCardView(recipe: recipe)
						}
					}
					.padding()
				}
			} else {
				EmptyView()
			}
		}
	}
}
