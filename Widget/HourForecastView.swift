//
//  HourForecastView.swift
//  Complicated Watch App
//
//  Created by Saagar Jha on 6/20/22.
//

import SwiftUI

struct HourForecastView: View {
	static let hourFormatSytle = Date.FormatStyle().hour(.twoDigits(amPM: .omitted))
	
	let forecast: WeatherForecast.HourForecast
	
	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				Image(systemName: forecast.condition)
					.renderingMode(.original)
					.scaleEffect(0.75)
				Spacer()
					.frame(height: 2)
			}
			VStack {
				Spacer()
				Text(WeatherForecastView.temperatureFormatter.string(from: forecast.temperature))
					.font(Font.system(size: 10).monospacedDigit())
			}
			HStack(spacing: 0) {
				Spacer()
				VStack(spacing: 0) {
					Text(forecast.current ? "NOW" : Self.hourFormatSytle.format(forecast.date.addingTimeInterval(30 * 60 /* Date format is effectively a truncation, so adjust by half an hour to round */)))
						.font(Font.system(size: 8).monospacedDigit())
						.foregroundColor(.secondary)
					Spacer()
				}.padding(.all, 0)
				Spacer()
					.frame(width: 1)
			}.padding(.all, 0)
		}
	}
}
