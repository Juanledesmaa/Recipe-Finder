//
//  CenteredScrollView.swift
//  RecipeFinder
//
//  Created by Juanito on 2/24/25.
//

import SwiftUI

struct CenteredVerticalScrollView<Content: View>: View {
	let content: () -> Content
	let onRefresh: (() async -> Void)?

	init(
		@ViewBuilder content: @escaping () -> Content,
		onRefresh: (() async -> Void)? = nil
	) {
		self.content = content
		self.onRefresh = onRefresh
	}

	var body: some View {
		GeometryReader { geometry in
			ScrollView(.vertical) {
				VStack {
					content()
				}
				.frame(width: geometry.size.width)
				.frame(minHeight: geometry.size.height)
			}
			.refreshable {
				if let onRefresh = onRefresh {
					await onRefresh()
				}
			}
		}
	}
}
