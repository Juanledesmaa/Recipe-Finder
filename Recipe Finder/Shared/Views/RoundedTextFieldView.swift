//
//  RoundedTextField.swift
//  RecipeFinder
//
//  Created by Juanito on 2/24/25.
//

import SwiftUI

struct RoundedTextFieldView: View {
	var placeholder: String
	@Binding var text: String
	var backgroundColor: Color = Color.gray.opacity(0.2)
	var cornerRadius: CGFloat = 25
	var horizontalPadding: CGFloat = 16
	var verticalPadding: CGFloat = 12

	var body: some View {
		TextField(placeholder, text: $text)
			.autocorrectionDisabled(true)
			.padding(.horizontal, horizontalPadding)
			.padding(.vertical, verticalPadding)
			.background(backgroundColor)
			.cornerRadius(cornerRadius)
			.textFieldStyle(.plain)
			.padding(.horizontal)
	}
}
