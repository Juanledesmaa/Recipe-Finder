//
//  RecipeCardView.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import SwiftUI

struct RecipeCardView: View {
	let recipe: Recipe

    var body: some View {
		ZStack {
			if let url = URL(
				string: recipe.photoUrlSmall ?? ""
			) {
				CachedAsyncImageView(url: url, placeholderImage: .dining)
					.scaledToFill()
					.opacity(0.7)
					.clipped()
			} else {
				Color.gray
			}
			
			VStack {
				Text(recipe.name)
					.foregroundStyle(.white)
					.font(.system(size: 24, weight: .bold))
					.lineLimit(3)
					.truncationMode(.tail)
				Text(recipe.cuisine)
					.foregroundStyle(.white.opacity(0.8))
					.font(.system(size: 22, weight: .medium))
					.lineLimit(1)
					.truncationMode(.tail)
			}
			.padding()
		}
		.background(.black)
		.cornerRadius(30)
		.shadow(radius: 4)
    }
}
