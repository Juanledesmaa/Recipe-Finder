//
//  MockNetworkClient.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/25/25.
//

import Foundation
@testable import My_Recipes_Private

final class MockNetworkClient: NetworkClientProtocol {
	var mockResponse: Result<RecipesList, Error> = .failure(
		NSError(
			domain: "",
			code: -1
		)
	)

	func request<T: Decodable>(url: URL, method: HTTPMethod) async throws -> T {
		switch mockResponse {
		case .success(let recipesList):
			return recipesList as! T
		case .failure(let error):
			throw error
		}
	}
}
