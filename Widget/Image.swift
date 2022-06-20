//
//  Image.swift
//  Complicated Watch App
//
//  Created by Saagar Jha on 6/20/22.
//

import SwiftUI

extension Image {
	func sized(_ size: CGFloat) -> some View {
		resizable().aspectRatio(contentMode: .fit).frame(height: size)
	}
}
