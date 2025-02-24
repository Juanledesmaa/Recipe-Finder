//
//  MockBundle.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/24/25.
//

import Foundation

final class MockBundle: Bundle, @unchecked Sendable {
	private let mockInfo: [String: Any]
	
	init(mockInfo: [String : Any]) {
		self.mockInfo = mockInfo
		super.init()
	}
	
	override func object(forInfoDictionaryKey key: String) -> Any? {
		return mockInfo[key]
	}
}
