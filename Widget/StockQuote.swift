//
//  StockQuote.swift
//  Widget
//
//  Created by Saagar Jha on 11/24/22.
//

import WidgetKit

struct StockQuote: TimelineEntry {
	let date: Date
	let symbol: String
	let price: Double
	let change: Double
	
	static let sample = StockQuote(date: .now, symbol: "BTC-USD", price: 42069, change: 0.99)
}
