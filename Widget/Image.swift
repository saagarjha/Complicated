//
//  Image.swift
//  Complicated Watch App
//
//  Created by Saagar Jha on 6/20/22.
//

import SwiftUI
import UIKit

extension Image {
	func sized(_ size: CGFloat) -> some View {
		resizable().aspectRatio(contentMode: .fit).frame(height: size)
	}

	static func filledVariantForSystemSymbolName(_ symbolName: String) -> String {
		let filledSymbolName = symbolName + ".fill"
		return UIImage(systemName: filledSymbolName) != nil ? filledSymbolName : symbolName
	}
}
