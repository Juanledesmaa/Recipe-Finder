//
//  RemoteRecipesListDataSource.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import Foundation

final class RemoteRecipesListDataSource: RecipesListDataSource {
	let apiClient: APIClientProtocol
	let apiConfiguration: RecipesListAPIConfiguration
	
	init(
		apiClient: APIClientProtocol,
		apiConfiguration: RecipesListAPIConfiguration
	) {
		self.apiClient = apiClient
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
		
		return try await apiClient.request(url: url, method: .get)
	}
}
