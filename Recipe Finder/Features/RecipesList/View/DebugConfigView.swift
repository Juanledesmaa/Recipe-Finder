//
//  DebugConfigView.swift
//  RecipeFinder
//
//  Created by Juanito on 2/25/25.
//

#if DEBUG

import SwiftUI

struct DebugConfigView: View {
	@ObservedObject private var debugConfig = RecipesListAPIConfiguration
		.DebugAPIConfig()

	var body: some View {
		Menu("⚙️ API Config") {
			ForEach(RecipesListAPIMode.allCases, id: \.self) { mode in
				Button(mode.rawValue) {
					debugConfig.selectedMode = mode
				}
			}
		}
		.padding(.trailing, 16)
	}
}
#endif

