//
//  MockAppConfiguration.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/25/25.
//

import Foundation
@testable import My_Recipes_Private

final class MockConfiguration: ConfigurationProtocol {
	var baseUrl: String

	init(baseUrl: String = "https://mockapi.com/") {
		self.baseUrl = baseUrl
	}
}
