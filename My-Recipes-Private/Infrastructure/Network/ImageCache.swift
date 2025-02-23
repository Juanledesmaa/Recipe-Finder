//
//  ImageCache.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import Foundation
import UIKit

final class ImageCache {
	static let shared = ImageCache()
	private let fileManager = FileManager.default
	private let cacheDirectory: URL
	
	private init() {
		guard let directory = fileManager.urls(
			for: .cachesDirectory,
			in: .userDomainMask
		).first else {
			fatalError("Unable to locate cache directory")
		}

		self.cacheDirectory = directory
	}
	
	func loadImage(from url: URL) async throws -> UIImage? {
		let localURL = fileURL(for: url)
		if fileManager.fileExists(atPath: localURL.path) {
			let data = try Data(contentsOf: localURL)
			return UIImage(data: data)
		} else {
			do {
				let (data, _) = try await URLSession.shared.data(from: url)
				try data.write(to: localURL)
				if let image = UIImage(data: data) {
					return image
				}
			} catch {
				print("Error fetching image: \(error.localizedDescription)")
			}
			
			return UIImage(systemName: "photo")
		}
		
	}
	
	private func fileURL(for url: URL) -> URL {
		let hashedFileName = url.absoluteString.addingPercentEncoding(
			withAllowedCharacters: .alphanumerics
		) ?? UUID().uuidString
		return cacheDirectory.appendingPathComponent(hashedFileName)
	}
}
