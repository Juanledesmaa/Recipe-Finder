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
				.navigationTitle(viewModel.viewData.navigationTitle)
				.background(Color.appColor.primaryBackground)
		}
		.task {
			await viewModel.fetchRecipesList()
		}
	}
	
	@ViewBuilder
	private var content: some View {
		VStack {
			TextField(
				viewModel.viewData.textFieldPlaceholder,
				text: $viewModel.searchQuery
			)
			.padding(.horizontal, 16)
			.padding(.vertical, 12)
			.background(Color.gray.opacity(0.2))
			.cornerRadius(25)
			.textFieldStyle(.plain)
			.padding()
			Spacer()
			
			switch viewModel.state {
				case .loading:
					ProgressView(viewModel.viewData.progressViewText)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				case .error:
					PlaceholderView(
						imageName: viewModel.viewData.errorImageName,
						title: viewModel.viewData.errorTitle,
						subtitle: viewModel.viewData.errorSubtitle,
						imageSize: viewModel.viewData.errorImageSize
					)
				case .empty:
					PlaceholderView(
						imageName: viewModel.viewData.emptyImageName,
						title: viewModel.viewData.emptyRecipesTitle
					)
				case .success:
					ScrollView {
						LazyVGrid(columns: columns, spacing: 16) {
							ForEach(
								viewModel.recipes,
								id: \.uuid
							) { recipe in
								RecipeCardView(recipe: recipe)
							}
						}
						.padding()
						.animation(
							.easeInOut,
							value: viewModel.recipes
						)
					}
					.refreshable {
						try? await Task.sleep(nanoseconds: 300_000_000)
						await viewModel.fetchRecipesList()
					}
					.transaction { $0.animation = nil }
			}
		}
	}
}
