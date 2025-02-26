//
//  URLSessionProtocol.swift
//  RecipeFinder
//
//  Created by Juanito on 2/25/25.
//

import Foundation

protocol URLSessionProtocol {
	func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
