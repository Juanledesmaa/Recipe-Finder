//
//  MockAppConfiguration.swift
//  RecipeFinder
//
//  Created by Juanito on 2/25/25.
//

import Foundation
@testable import Recipe_Finder

final class MockConfiguration: ConfigurationProtocol {
	var baseUrl: String

	init(baseUrl: String = "https://mockapi.com/") {
		self.baseUrl = baseUrl
	}
}
