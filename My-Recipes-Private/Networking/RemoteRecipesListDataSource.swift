//
//  RemoteRecipesListDataSource.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import Foundation

final class RemoteRecipesListDataSource: RecipesListDataSource {
	let networkClient: NetworkClientProtocol
	let apiConfiguration: RecipesListAPIConfiguration
	
	init(
		networkClient: NetworkClientProtocol,
		apiConfiguration: RecipesListAPIConfiguration
	) {
		self.networkClient = networkClient
		self.apiConfiguration = apiConfiguration
	}
	
	func fetchRecipes() async throws -> RecipesList {
		guard let url = apiConfiguration.makeRecipesListURL() else {
			throw NSError(
				domain: "",
				code: -1,
				userInfo: [
					NSLocalizedDescriptionKey: "Invalid URL"
				]
			)
		}
		
		return try await networkClient.request(url: url, method: .get)
	}
}
