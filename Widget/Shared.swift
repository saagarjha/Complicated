//
//  Shared.swift
//  Complicated
//
//  Created by Saagar Jha on 11/26/22.
//

import Foundation

enum ComplicatedWidgets: CaseIterable {
	case weather
	case stocks
	
	var kind: String {
		switch self {
		case .weather:
			return "com.saagarjha.Complicated.WeatherWidget"
		case .stocks:
			return "com.saagarjha.Complicated.StocksWidget"
		}
	}
	
	var url: URL {
		switch self {
		case .weather:
			return URL(string: "complicated://weather")!
		case .stocks:
			return URL(string: "complicated://stocks")!
		}
	}
	
	var correspondingApp: String {
		switch self {
		case .weather:
			return "com.apple.weather.watchapp"
		case .stocks:
			return "com.apple.stocks.watchapp"
		}
	}
}
