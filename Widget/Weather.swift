//
//  Weather.swift
//  Complicated Watch App
//
//  Created by Saagar Jha on 6/20/22.
//

import Foundation
import WeatherKit

protocol Weather {
	var date: Date { get }
	var current: Bool { get }
	var symbolName: String { get }
	var temperature: Measurement<UnitTemperature> { get }
	var visibility: Measurement<UnitLength> { get }
	var wind: Wind { get }
}

extension CurrentWeather: Weather {
	var current: Bool {
		return true
	}
}

extension HourWeather: Weather {
	var current: Bool {
		return false
	}
}
