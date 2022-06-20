//
//  RoundedTextView.swift
//  Widget
//
//  Created by Saagar Jha on 11/25/22.
//

import SwiftUI

enum WidthKey: PreferenceKey {
	static var defaultValue = [Character: CGFloat]()
	
	static func reduce(value: inout [Character: CGFloat], nextValue: () -> [Character: CGFloat]) {
		value.merge(nextValue()) { _, _ in
			fatalError()
		}
	}
}

struct WidthSizingView: View {
	let characters: [Character]
	
	var body: some View {
		ForEach(Array(Set(characters)), id: \.self) { character in
			Text(String(character))
				.background(GeometryReader { geometry in
					Color.clear.preference(key: WidthKey.self, value: [character: geometry.size.width])
				})
		}.hidden()
	}
}

enum HeightKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}

struct HeightSizingView: View {
	let text: String
	
	var body: some View {
		Text(text)
			.background(GeometryReader { geometry in
				Color.clear.preference(key: HeightKey.self, value: geometry.size.height)
			})
		.hidden()
	}
}

struct RoundedTextView: View {
	enum Position {
		case top
		case bottom
	}
	
	let text: String
	let position: Position
	@State
	var widths = [Character: CGFloat]()
	@State
	var height: CGFloat = 0
	
	var body: some View {
		let characters = Array(text)
		ZStack {
			WidthSizingView(characters: characters)
			HeightSizingView(text: text)
			if !widths.isEmpty {
				GeometryReader { geometry in
					let radius = min(geometry.size.height / 2, geometry.size.width / 2) - height / 2
					let radiusCorrection = 1 + height / radius / 4
					let widths = self.widths.mapValues {
						radius * 2 * asin($0 / 2 / radius) * radiusCorrection
					}
					var prefixWidths = text.reduce(into: [0]) {
						$0.append($0.last! + widths[$1]!)
					}
					let totalWidth = prefixWidths.removeLast()
					let _ = precondition(totalWidth < 2 * .pi * radius)
					let totalAngle = totalWidth / radius
					ZStack {
						ForEach(0..<characters.count, id: \.self) { index in
							let start: CGFloat = position == .top ? CGFloat.pi / 2 : 3 * CGFloat.pi / 2
							let direction: CGFloat = position == .top ? -1 : 1

							let angle = start - direction * totalAngle / 2 + direction * totalAngle * (prefixWidths[index] + widths[characters[index]]! / 2) / totalWidth
							let offsetX = radius * cos(angle)
							let offsetY = radius * sin(angle)
							Text(String(characters[index]))
								.rotationEffect(.radians(start - angle))
								.position(x: geometry.size.width / 2 + offsetX, y: geometry.size.height / 2 - offsetY)
						}
					}
				}
			}
		}.onPreferenceChange(WidthKey.self) {
			self.widths = $0
		}.onPreferenceChange(HeightKey.self) {
			self.height = max($0, self.height)
		}
	}
}

