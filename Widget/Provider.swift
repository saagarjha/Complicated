//
//  Provider.swift
//  Complicated Watch App
//
//  Created by Saagar Jha on 6/20/22.
//

import WeatherKit
import WidgetKit

struct Provider: TimelineProvider {
	typealias Entry = WeatherForecast

	func placeholder(in context: Context) -> Entry {
		.sample
	}

	func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
		if context.isPreview {
			completion(.sample)
		} else {
			completion(.sample)
		}
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
		if context.isPreview {
			completion(
				Timeline(
					entries: [
						.sample
					], policy: .atEnd))
		} else {
			Task {
				guard let location = await Location.current else {
					completion(Timeline(entries: [], policy: .atEnd))
					return
				}
				let (current, hourly, daily) = try! await WeatherService.shared.weather(for: location, including: .current, .hourly, .daily)

				func day(for time: Date) -> DayWeather {
					daily.filter {
						$0.date < time
					}.min {
						(time.timeIntervalSince1970 - $0.date.timeIntervalSince1970) < (time.timeIntervalSince1970 - $1.date.timeIntervalSince1970)
					}!
				}

				let weather =
					[current] as [Weather]
					+ Array(
						hourly.sorted {
							$0.date < $1.date
						}.filter {
							$0.date > current.date
						})

				let hourForecasts = weather.map { forecast in
					WeatherForecast.HourForecast(date: forecast.date, temperature: forecast.temperature, condition: forecast.symbolName + ".fill")
				}
				var hourForecastsIndex = hourForecasts.startIndex
				func hourlyForecasts(for time: Date) -> ArraySlice<WeatherForecast.HourForecast> {
					hourForecastsIndex =
						hourForecasts[hourForecastsIndex...].firstIndex {
							$0.date >= time
						} ?? hourForecasts.endIndex
					return hourForecasts[hourForecastsIndex...]
				}

				let sunEvents = (daily.compactMap(\.sun.sunrise).map(WeatherForecast.SunEvent.sunrise) + daily.compactMap(\.sun.sunset).map(WeatherForecast.SunEvent.sunset)).sorted {
					$0.date < $1.date
				}

				var sunEventsIndex = sunEvents.startIndex
				func sunEvent(for time: Date) -> WeatherForecast.SunEvent? {
					sunEventsIndex =
						sunEvents[sunEventsIndex...].firstIndex {
							$0.date > time
						} ?? sunEvents.endIndex
					return sunEventsIndex != sunEvents.endIndex && sunEvents[sunEventsIndex].date.timeIntervalSince(time) < 24 * 60 * 60 ? sunEvents[sunEventsIndex] : nil
				}

				var hourlyIndex = hourly.startIndex
				func precipitationChance(for time: Date) -> Double {
					hourlyIndex =
						zip(hourlyIndex..., hourly.index(after: hourlyIndex)..<hourly.endIndex).first { index1, index2 in
							abs(time.timeIntervalSince1970 - hourly[index1].date.timeIntervalSince1970) < abs(time.timeIntervalSince1970 - hourly[index2].date.timeIntervalSince1970)
						}?.0 ?? hourly.dropLast().endIndex
					return hourly[hourlyIndex].precipitationChance
				}

				let forecasts = weather.prefix(25) /* if you give too many WidgetKit gets upset */.map { forecast in
					WeatherForecast(
						date: forecast.date,
						hourly: hourlyForecasts(for: forecast.date),
						low: day(for: forecast.date).lowTemperature,
						high: day(for: forecast.date).highTemperature,
						precipitationChance: precipitationChance(for: forecast.date),
						visibility: forecast.visibility,
						windSpeed: forecast.wind.speed,
						windDirection: forecast.wind.direction,
						sunEvent: sunEvent(for: forecast.date),
						lastRefresh: .now
					)
				}

				var entries = [WeatherForecast]()

				var forecastIndex = forecasts.startIndex
				for (sunEvent, nextSunEvent) in zip(sunEvents, sunEvents.dropFirst()) {
					if let upper = forecasts[forecastIndex...].firstIndex(where: { $0.date > sunEvent.date }) {
						guard upper > forecasts.startIndex else {
							continue
						}
						let lower = forecasts.index(before: upper)
						let time: (Int) -> Double = { abs(forecasts[$0].date.timeIntervalSince1970 - sunEvent.date.timeIntervalSince1970) }
						var forecast = time(lower) < time(upper) ? forecasts[lower] : forecasts[upper]
						forecast.date = sunEvent.date
						forecast.sunEvent = nextSunEvent
						entries.append(contentsOf: forecasts[forecastIndex..<upper])
						entries.append(forecast)
						forecastIndex = upper
					} else {
						entries.append(contentsOf: forecasts[forecastIndex...])
						break
					}
				}

				completion(Timeline(entries: entries, policy: .after(.now.addingTimeInterval(60 * 60))))
			}
		}
	}
}
