//
//  RecipeFinderApp.swift
//  RecipeFinder
//
//  Created by Juanito on 2/19/25.
//

import SwiftUI

struct Environment {
	#if DEBUG
	static let isDebug = true
	#else
	static let isDebug = false
	#endif
}

@main
struct RecipeFinderApp: App {
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
