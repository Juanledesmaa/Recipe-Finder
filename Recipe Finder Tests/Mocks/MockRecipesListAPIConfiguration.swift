//
//  MockRecipesListAPIConfiguration.swift
//  RecipeFinder
//
//  Created by Juanito on 2/25/25.
//

import Foundation
@testable import Recipe_Finder

final class MockRecipesListAPIConfiguration: RecipesListAPIConfiguration {
	var mockURL: URL?

	override func makeRecipesListURL() -> URL? {
		return mockURL
	}
}
