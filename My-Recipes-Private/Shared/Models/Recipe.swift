//
//  Recipe.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/19/25.
//

import Foundation

struct Recipe: Decodable, Equatable {
	let uuid: String
	let name: String
	let cuisine: String
	
	let photoUrlLarge: String?
	let photoUrlSmall: String?
	let sourceUrl: String?
	let youtubeUrl: String?
}
