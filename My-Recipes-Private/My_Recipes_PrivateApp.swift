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
			let networkClient = NetworkClient(
				session: URLSession(
					configuration: .ephemeral
				)
			)
			let appConfiguration = AppConfiguration()
			let recipesListAPIConfiguration = RecipesListAPIConfiguration(
				configuration: appConfiguration
			)
			
			let remoteDataSource = RemoteRecipesListDataSource(
				networkClient: networkClient,
				apiConfiguration: recipesListAPIConfiguration
			)

			let viewModel = RecipesListViewModel(
				recipesListDataSource: remoteDataSource
			)
			RecipesListView(viewModel: viewModel)
        }
    }
}
