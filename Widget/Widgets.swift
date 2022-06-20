//
//  Widgets.swift
//  Widgets
//
//  Created by Saagar Jha on 6/18/22.
//

import CoreLocation
import SwiftUI
import WatchKit
import WeatherKit
import WidgetKit

@main
struct Widgets: WidgetBundle {
	init() {
		URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0)
	}
	
	@WidgetBundleBuilder
	var body: some Widget {
		WeatherWidget()
		StocksWidget()
	}
}

struct WeatherWidget: Widget {
	static let widget = ComplicatedWidgets.weather
	
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: Self.widget.kind, provider: WeatherProvider()) { entry in
			WeatherForecastView(weatherForecast: entry)
				.widgetURL(Self.widget.url)
		}
		.configurationDisplayName("Complicated Weather")
		.description("A Complicated weather widget.")
		.supportedFamilies([.accessoryRectangular])
	}
}

struct StocksWidget: Widget {
	static let widget = ComplicatedWidgets.stocks
	
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: Self.widget.kind, provider: StocksProvider()) { entry in
			StockView(stockQuote: entry)
				.widgetURL(Self.widget.url)
		}
		.configurationDisplayName("Complicated Stocks")
		.description("A Complicated stocks widget.")
		.supportedFamilies([.accessoryCircular])
	}
}

struct Widget_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			WeatherForecastView(weatherForecast: .sample)
				.previewDisplayName("Weather")
				.previewContext(WidgetPreviewContext(family: .accessoryRectangular))
			StockView(stockQuote: .sample)
				.previewDisplayName("Stock")
				.previewContext(WidgetPreviewContext(family: .accessoryCircular))
		}
	}
}

extension Widgets {
	static let small = WKInterfaceDevice.current().screenBounds.width < 170
}
