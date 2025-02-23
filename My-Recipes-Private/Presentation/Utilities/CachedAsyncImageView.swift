//
//  AsyncImageView.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import SwiftUI

struct CachedAsyncImageView: View {
	let url: URL
	@StateObject var imageLoader: ImageLoader
	
	init(url: URL) {
		self.url = url
		_imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
	}
	
	var body: some View {
		Group {
			switch imageLoader.phase {
				case .empty:
					Color.gray
				case .success(let image):
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
				case .failure(_):
					Image(systemName: "photo")
						.resizable()
				@unknown default:
					Image(systemName: "photo")
						.resizable()
			}
		}
		.onAppear {
			Task {
				await imageLoader.load()
			}
		}
	}
}
