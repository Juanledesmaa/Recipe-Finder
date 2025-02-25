//
//  ConfigurationManager.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/19/25.
//

import Foundation

struct AppConfiguration: ConfigurationProtocol {
	
	var baseUrl: String {
		return bundle.object(
			forInfoDictionaryKey: "BaseURL"
		) as? String ?? ""
	}
	
	private let bundle: Bundle

	init(bundle: Bundle = .main) {
		self.bundle = bundle
	}
}
