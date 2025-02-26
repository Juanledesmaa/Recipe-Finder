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
	private static let sharedSession = URLSession.shared
	private let session: URLSessionProtocol
	
	init(
		session: URLSessionProtocol = sharedSession,
		cacheDirectory: URL? = nil
	) {
		if let cacheDirectory = cacheDirectory {
			self.cacheDirectory = cacheDirectory
		} else {
			guard let directory = fileManager.urls(
				for: .cachesDirectory,
				in: .userDomainMask
			).first else {
				fatalError("Unable to locate cache directory")
			}
			self.cacheDirectory = directory
		}
		self.session = session
	}

	func loadImage(from url: URL) async throws -> UIImage? {
		let localURL = ImageCache.fileURL(for: url, using: cacheDirectory)
		if fileManager.fileExists(atPath: localURL.path) {
			let data = try Data(contentsOf: localURL)
			return UIImage(data: data)
		} else {
			do {
				let (data, _) = try await session.data(
					for: URLRequest(
						url: url
					)
				)
				try data.write(to: localURL)
				if let image = UIImage(data: data) {
					return image
				} else {
					return nil
				}
			} catch {
				return nil
			}
		}
		
	}
	
	static func fileURL(for url: URL, using directory: URL) -> URL {
		let hashedFileName = url.absoluteString.addingPercentEncoding(
			withAllowedCharacters: .alphanumerics
		) ?? UUID().uuidString
		return directory.appendingPathComponent(hashedFileName)
	}
	
	func clearCache() {
		do {
			let fileURLs = try fileManager.contentsOfDirectory(
				at: cacheDirectory,
				includingPropertiesForKeys: nil
			)
			for fileURL in fileURLs {
				try fileManager.removeItem(at: fileURL)
			}
		} catch {
			print("Failed to clear cache: \(error.localizedDescription)")
		}
	}
}
