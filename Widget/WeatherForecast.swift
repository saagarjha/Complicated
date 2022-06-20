//
//  WeatherForecast.swift
//  Complicated Watch App
//
//  Created by Saagar Jha on 6/20/22.
//

import WidgetKit

struct WeatherForecast: TimelineEntry {
	struct HourForecast: Identifiable {
		let date: Date
		let temperature: Measurement<UnitTemperature>
		let condition: String
		let current: Bool

		var id: Date {
			date
		}
	}

	enum SunEvent {
		case sunrise(Date)
		case sunset(Date)

		var date: Date {
			switch self {
				case .sunrise(let date), .sunset(let date):
					return date
			}
		}
	}

	var date: Date

	let hourly: ArraySlice<HourForecast>
	let low: Measurement<UnitTemperature>
	let high: Measurement<UnitTemperature>
	let precipitationChance: Double
	let visibility: Measurement<UnitLength>
	let windSpeed: Measurement<UnitSpeed>
	let windDirection: Measurement<UnitAngle>
	var sunEvent: SunEvent?
	let airQuality: Double?

	let lastRefresh: Date

	static let sample = WeatherForecast(
		date: .now,
		hourly: [
			HourForecast(date: Date().addingTimeInterval(0 * 60 * 60), temperature: .init(value: -20, unit: .celsius), condition: "sun.max.fill", current: true),
			HourForecast(date: Date().addingTimeInterval(1 * 60 * 60), temperature: .init(value: -10, unit: .celsius), condition: "cloud.sun.fill", current: false),
			HourForecast(date: Date().addingTimeInterval(2 * 60 * 60), temperature: .init(value: 0, unit: .celsius), condition: "cloud.sun.rain.fill", current: false),
			HourForecast(date: Date().addingTimeInterval(3 * 60 * 60), temperature: .init(value: 10, unit: .celsius), condition: "cloud.sun.bolt.fill", current: false),
			HourForecast(date: Date().addingTimeInterval(4 * 60 * 60), temperature: .init(value: 20, unit: .celsius), condition: "moon.stars.fill", current: false),
		],
		low: .init(value: -42, unit: .celsius),
		high: .init(value: 69, unit: .celsius),
		precipitationChance: 1,
		visibility: .init(value: 42, unit: .kilometers),
		windSpeed: .init(value: 42, unit: .kilometersPerHour),
		windDirection: .init(value: 1, unit: .radians),
		sunEvent: .sunrise(.init(timeIntervalSince1970: -4 * 60 * 60)),
		airQuality: 420,
		lastRefresh: .now
	)
}
