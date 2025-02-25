//
//  RecipesListAPIConfiguration.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import Foundation

final class RecipesListAPIConfiguration {

	private let configuration: ConfigurationProtocol

	init(configuration: ConfigurationProtocol) {
		self.configuration = configuration
	}

	func makeRecipesListURL() -> URL? {
		let baseUrl = configuration.baseUrl
		let path = "recipes.json"

		return URL(string: "\(baseUrl)\(path)")
	}
}
