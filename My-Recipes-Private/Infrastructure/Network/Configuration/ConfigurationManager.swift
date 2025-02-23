//
//  ConfigurationManager.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/19/25.
//

import Foundation

struct AppConfiguration: ConfigurationProtocol {
	var baseUrl: String {
		return Bundle.main.object(
			forInfoDictionaryKey: "BaseURL"
		) as? String ?? ""
	}
}
