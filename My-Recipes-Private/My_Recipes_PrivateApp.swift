//
//  My_Recipes_PrivateApp.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/19/25.
//

import SwiftUI

@main
struct My_Recipes_PrivateApp: App {
    var body: some Scene {
        WindowGroup {
			let apiClient = APIClient(
				session: URLSession(
					configuration: .ephemeral
				)
			)
			let appConfiguration = AppConfiguration()
			let recipesListAPIConfiguration = RecipesListAPIConfiguration(
				configuration: appConfiguration
			)
			
			let remoteDataSource = RemoteRecipesListDataSource(
				apiClient: apiClient,
				apiConfiguration: recipesListAPIConfiguration
			)

			let repository = RecipesListRepositoryImplementation(
				dataSource: remoteDataSource
			)
			let fetchRecipesListUseCase = FetchRecipesListUseCase(
				repository: repository
			)
			let viewModel = RecipesListViewModel(
				fetchRecipesListUseCase: fetchRecipesListUseCase
			)
			RecipesListView(viewModel: viewModel)
        }
    }
}
