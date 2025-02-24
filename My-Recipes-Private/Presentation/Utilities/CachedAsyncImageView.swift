//
//  AsyncImageView.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import SwiftUI

struct CachedAsyncImageView: View {
	let url: URL
	let placeholderImage: UIImage?
	@StateObject var imageLoader: ImageLoader
	
	init(url: URL, placeholderImage: UIImage? = nil) {
		self.url = url
		self.placeholderImage = placeholderImage
		_imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
	}
	
	var body: some View {
		Group {
			switch imageLoader.phase {
				case .empty, .failure(_):
					if let placeholderImage = placeholderImage {
						Image(uiImage: placeholderImage)
							.resizable()
							.aspectRatio(contentMode: .fit)
					}
					Color.gray.opacity(0.6)
				case .success(let image):
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
				@unknown default:
					if let placeholderImage = placeholderImage {
						Image(uiImage: placeholderImage)
							.resizable()
							.aspectRatio(contentMode: .fit)
					}
					Color.gray.opacity(0.6)
			}
		}
		.onAppear {
			Task {
				await imageLoader.load()
			}
		}
	}
}
