//
//  StockView.swift
//  Widget
//
//  Created by Saagar Jha on 11/24/22.
//

import SwiftUI
import WidgetKit

struct StockView: View {
	static let priceFormatter: NumberFormatter = {
		let priceFormatter = NumberFormatter()
		priceFormatter.numberStyle = .currency
		priceFormatter.currencySymbol = ""
		return priceFormatter
	}()
	
	static let changeFormatter: NumberFormatter = {
		let changeFormatter = NumberFormatter()
		changeFormatter.numberStyle = .percent
		changeFormatter.minimumFractionDigits = 2
		changeFormatter.positivePrefix = changeFormatter.plusSign
		return changeFormatter
	}()
	
	let stockQuote: StockQuote
	
	var body: some View {
		ZStack {
			AccessoryWidgetBackground()
			RoundedTextView(text: Self.changeFormatter.string(from: stockQuote.change as NSNumber)!, position: .top)
				.foregroundColor(stockQuote.change >= 0 ? .green : .red)
				.font(Font.system(size: 8).bold())
			VStack {
				Text("")
				Text(Self.priceFormatter.string(from: stockQuote.price as NSNumber)!)
					.minimumScaleFactor(0.1)
				Text("")
			}
			RoundedTextView(text: stockQuote.symbol, position: .bottom)
				.foregroundColor(.secondary)
				.font(Font.system(size: 8).bold())
		}
	}
}
