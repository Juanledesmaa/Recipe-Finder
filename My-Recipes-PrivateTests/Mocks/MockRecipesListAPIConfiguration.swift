//
//  MockRecipesListAPIConfiguration.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/25/25.
//

import Foundation
@testable import My_Recipes_Private

final class MockRecipesListAPIConfiguration: RecipesListAPIConfiguration {
	var mockURL: URL?

	override func makeRecipesListURL() -> URL? {
		return mockURL
	}
}
