//
//  Widget.swift
//  Widget
//
//  Created by Saagar Jha on 6/18/22.
//

import CoreLocation
import SwiftUI
import WeatherKit
import WidgetKit

@main
struct Widget: SwiftUI.Widget {
	let kind: String = "Widget"

	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			WeatherForecastView(weatherForecast: entry)
		}
		.configurationDisplayName("Complicated")
		.description("A Complicated Weather widget.")
	}
}

struct Widget_Previews: PreviewProvider {
	static var previews: some View {
		WeatherForecastView(weatherForecast: WeatherForecast.sample)
			.previewContext(WidgetPreviewContext(family: .accessoryRectangular))
	}
}
