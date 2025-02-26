//
//  NetworkClientProtocol.swift
//  RecipeFinder
//
//  Created by Juanito on 2/19/25.
//

import Foundation

protocol NetworkClientProtocol {
	func request<T: Decodable>(url: URL, method: HTTPMethod) async throws -> T
}
