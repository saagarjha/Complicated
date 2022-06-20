//
//  WeatherForecastView.swift
//  Complicated Watch App
//
//  Created by Saagar Jha on 6/20/22.
//

import SwiftUI

struct WeatherForecastView: View {
	static let temperatureFormatter: MeasurementFormatter = {
		let temperatureFormatter = MeasurementFormatter()
		temperatureFormatter.unitOptions = .temperatureWithoutUnit
		temperatureFormatter.numberFormatter.maximumFractionDigits = 0
		return temperatureFormatter
	}()
	static let percentFormatter: NumberFormatter = {
		let percentFormatter = NumberFormatter()
		percentFormatter.numberStyle = .percent
		return percentFormatter
	}()
	static let distanceFormatter: MeasurementFormatter = {
		let distanceFormatter = MeasurementFormatter()
		distanceFormatter.numberFormatter.maximumFractionDigits = 0
		return distanceFormatter
	}()
	static let timeFormatter: DateFormatter = {
		let timeFormatter = DateFormatter()
		timeFormatter.dateStyle = .none
		timeFormatter.timeStyle = .short
		timeFormatter.amSymbol = ""
		timeFormatter.pmSymbol = ""
		return timeFormatter
	}()
	static let airQualityFormatter: NumberFormatter = {
		let airQualityFormatter = NumberFormatter()
		airQualityFormatter.maximumFractionDigits = 0
		return airQualityFormatter
	}()
	static let debugDateFormatter: DateFormatter = {
		let debugDateFormatter = DateFormatter()
		debugDateFormatter.dateFormat = "MM/dd HH:mm"
		return debugDateFormatter
	}()
	static let dividerHeight: CGFloat = 40
	static let windColor = Color(hue: 0.55, saturation: 1, brightness: 1)

	let weatherForecast: WeatherForecast

	static func color(forAirQuality airQuality: Double) -> Color {
		switch airQuality {
			case 0..<50:
				return .green
			case 50..<100:
				return .yellow
			case 100..<150:
				return .orange
			case 150..<200:
				return .red
			case 200..<250:
				return .purple
			default:
				return Color(hue: 0, saturation: 1, brightness: 0.75)
		}
	}

	var body: some View {
		VStack(spacing: Widgets.small ? 1 : 2) {
			HStack {
				InlineLabel(image: "arrow.up.arrow.down", text: "\(Self.temperatureFormatter.string(from: weatherForecast.low))/\(Self.temperatureFormatter.string(from: weatherForecast.high))", flip: true)
				Spacer()
				InlineLabel(image: "umbrella", text: Self.percentFormatter.string(from: weatherForecast.precipitationChance as NSNumber)!, color: .blue)
				Spacer()
				InlineLabel(image: "cloud.fog", text: Self.distanceFormatter.string(from: weatherForecast.visibility), color: .gray)
			}
			HStack(spacing: 0) {
				Divider()
					.frame(height: Self.dividerHeight)
				ForEach(weatherForecast.hourly.prefix(5)) { hourForecast in
					HourForecastView(forecast: hourForecast)
						.frame(maxWidth: .infinity, minHeight: Self.dividerHeight)
					Divider()
						.frame(height: Self.dividerHeight)
				}
			}
			HStack {
				HStack(spacing: 2) {
					InlineLabel(image: "wind", text: "\(Self.distanceFormatter.string(from: weatherForecast.windSpeed))", color: Self.windColor, additionalText: ("↓", weatherForecast.windDirection.converted(to: .radians).value))
				}
				Spacer()
				switch weatherForecast.sunEvent {
					case .none:
						InlineLabel(image: "sunrise", text: "--:--", color: .orange)
					case .sunrise(let date):
						InlineLabel(image: "sunrise", text: Self.timeFormatter.string(from: date), color: .orange)
					case .sunset(let date):
						InlineLabel(image: "sunset", text: Self.timeFormatter.string(from: date), color: .orange)
				}
				Spacer()
				if let airQuality = weatherForecast.airQuality {
					InlineLabel(image: "speedometer", text: "\(Self.airQualityFormatter.string(from: airQuality as NSNumber)!)", color: Self.color(forAirQuality: airQuality))
				} else {
					// Debugging information about refreshes
					VStack(spacing: 0) {
						HStack(spacing: 0) {
							Spacer()
							Text("\(Self.debugDateFormatter.string(from: weatherForecast.lastRefresh))")
								.font(.system(size: Widgets.small ? 5 : 6))
								.monospacedDigit()
								.truncationMode(.head)
							Spacer()
						}
						HStack(spacing: 0) {
							Spacer()
							Text(weatherForecast.date, style: .timer)
								.font(.system(size: Widgets.small ? 5 : 6))
								.monospacedDigit()
							Spacer()
						}
					}
					.layoutPriority(-1)
				}
			}
		}
	}
}
