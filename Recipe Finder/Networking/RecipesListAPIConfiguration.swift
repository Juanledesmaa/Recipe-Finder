//
//  RecipesListAPIConfiguration.swift
//  RecipeFinder
//
//  Created by Juanito on 2/22/25.
//

import Foundation

enum RecipesListAPIMode: String, CaseIterable {
	case full = "recipes.json"
	case empty = "recipes-empty.json"
	case malformed = "recipes-malformed.json"
}

class RecipesListAPIConfiguration {
	private let configuration: ConfigurationProtocol
	private var apiMode: RecipesListAPIMode = .full
	
	init(
		configuration: ConfigurationProtocol,
		apiMode: RecipesListAPIMode = .full
	) {
		self.configuration = configuration
	}
	
	func makeRecipesListURL() -> URL? {
		let baseUrl = configuration.baseUrl
#if DEBUG
		apiMode = DebugAPIConfig().selectedMode
#endif
		return URL(
			string: "\(baseUrl)\(apiMode.rawValue)"
		)
	}
}

// MARK: - Debug API Config

extension RecipesListAPIConfiguration {
#if DEBUG
	class DebugAPIConfig: ObservableObject {
		@Published var selectedMode: RecipesListAPIMode {
			didSet {
				UserDefaults.standard.set(
					selectedMode.rawValue,
					forKey: "selectedAPIMode"
				)
			}
		}
		
		init() {
			let savedSelectedAPIMode = UserDefaults.standard.string(
				forKey: "selectedAPIMode"
			) ?? RecipesListAPIMode.full.rawValue
			self.selectedMode = RecipesListAPIMode(
				rawValue: savedSelectedAPIMode
			) ?? .full
		}
	}
#endif
}
