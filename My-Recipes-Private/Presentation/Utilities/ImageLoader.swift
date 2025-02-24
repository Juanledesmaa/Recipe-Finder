//
//  ImageLoader.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import SwiftUI

final class ImageLoader: ImageLoaderProtocol {
	@Published var phase: AsyncImagePhase = .empty

	private let url: URL?
	private let urlSession: URLSession
	private let cache: URLCache
	
	private static let defaultCache: URLCache = {
		URLCache(
			memoryCapacity: 100 * 1024 * 1024,
			diskCapacity: 500 * 1024 * 1024,
			diskPath: "RecipesList-imagesCache"
		)
	}()
	
	private static let imageSession: URLSession = {
		let configuration = URLSessionConfiguration.ephemeral
		configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
		return URLSession(configuration: configuration)
	}()
	
	init(
		url: URL?,
		phase: AsyncImagePhase = .empty,
		urlSession: URLSession = ImageLoader.imageSession,
		cache: URLCache = ImageLoader.defaultCache
	) {
		self.url = url
		self.phase = phase
		self.urlSession = urlSession
		self.cache = cache
	}
	
	@MainActor
	func load() async {
		phase = .empty
		
		guard let url else {
			updatePhase(.failure(URLError(.badURL)))
			return
		}
		
		let request = URLRequest(url: url)
		if let cachedResponse = cache.cachedResponse(for: request),
		   let cachedImage = UIImage(data: cachedResponse.data) {
			updatePhase(.success(Image(uiImage: cachedImage)))
			return
		}
		
		do {
			let (data, response) = try await urlSession.data(for: request)
			
			guard let httpResponse = response as? HTTPURLResponse,
					httpResponse.statusCode == 200 else {
				throw URLError(.badServerResponse)
			}
			
			if let image = UIImage(data: data) {
				cache.storeCachedResponse(
					CachedURLResponse(
						response: response,
						data: data
					),
					for: request
				)
				updatePhase(.success(Image(uiImage: image)))
			} else {
				throw URLError(.cannotDecodeContentData)
			}
		} catch {
			updatePhase(.failure(error))
		}
	}

	private func updatePhase(_ newPhase: AsyncImagePhase) {
		withAnimation(.easeIn(duration: 0.1)) {
			phase = newPhase
		}
	}
}
