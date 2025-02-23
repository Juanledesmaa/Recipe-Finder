//
//  APIClientProtocol.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/19/25.
//

import Foundation

protocol APIClientProtocol {
	func request<T: Decodable>(url: URL, method: HTTPMethod) async throws -> T
}
