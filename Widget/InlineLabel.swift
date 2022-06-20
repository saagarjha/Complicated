//
//  InlineLabel.swift
//  Complicated Watch App
//
//  Created by Saagar Jha on 6/20/22.
//

import SwiftUI

struct InlineLabel: View {
	static let font = Font.system(size: 11.5).monospacedDigit()
	static let imageSize: CGFloat = 9

	let image: String
	let text: String

	var color: Color?
	var additionalText: (String, Double)?
	var flip = false

	var body: some View {
		HStack {
			Image(systemName: image)
				.sized(Self.imageSize)
				.foregroundColor(color)
				.scaleEffect(x: flip ? -1 : 1, y: 1)
			HStack(spacing: 2) {
				Text(text)
					.font(Self.font)
					.foregroundColor(color)
				if let (additionalText, rotation) = additionalText {
					Text(additionalText)
						.font(Self.font)
						.foregroundColor(color)
						.rotationEffect(.radians(rotation))
				}
			}
		}
	}
}
