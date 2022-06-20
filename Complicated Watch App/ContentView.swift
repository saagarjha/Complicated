//
//  ContentView.swift
//  Complicated Watch App
//
//  Created by Saagar Jha on 6/18/22.
//

import CoreLocation
import SwiftUI
import WidgetKit

@objc protocol _LSApplicationWorkspace {
	static func defaultWorkspace() -> Self
	@objc(openURL:)
	func open(_ url: URL)
}

let LSApplicationWorkspace = unsafeBitCast(NSClassFromString("LSApplicationWorkspace"), to: _LSApplicationWorkspace.Type.self)

struct ContentView: View {
	static let locationManager = CLLocationManager()

	var body: some View {
		Color.clear.onAppear {
			NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "UIApplicationDidBecomeActiveNotification"), object: nil, queue: .main) { _ in
				Self.runLaunchActions()
			}
			Self.runLaunchActions()
		}
	}

	static func runLaunchActions() {
		switch Self.locationManager.authorizationStatus {
			case .authorizedAlways, .authorizedWhenInUse:
				break
			default:
				Self.locationManager.requestWhenInUseAuthorization()
		}
		LSApplicationWorkspace.defaultWorkspace().open(URL(string: "com.apple.NanoWeather://")!)
		WidgetCenter.shared.reloadAllTimelines()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
