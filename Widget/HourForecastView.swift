//
//  HourForecastView.swift
//  Complicated Watch App
//
//  Created by Saagar Jha on 6/20/22.
//

import SwiftUI

struct HourForecastView: View {
	let forecast: WeatherForecast.HourForecast

	var body: some View {
		VStack(spacing: 8) {
			Image(systemName: forecast.condition)
				.renderingMode(.original)
				.sized(12)
			Text(WeatherForecastView.temperatureFormatter.string(from: forecast.temperature))
				.font(Font.system(size: 10).monospacedDigit())
		}
	}
}
