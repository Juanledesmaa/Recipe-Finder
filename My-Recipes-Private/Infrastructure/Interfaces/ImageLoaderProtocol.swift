//
//  ImageLoaderProtocol.swift
//  My-Recipes-Private
//
//  Created by Juanito on 2/22/25.
//

import SwiftUI

protocol ImageLoaderProtocol: ObservableObject {
	var phase: AsyncImagePhase { get }
	func load() async
}

