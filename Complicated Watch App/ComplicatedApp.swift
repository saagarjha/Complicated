//
//  ComplicatedApp.swift
//  Complicated Watch App
//
//  Created by Saagar Jha on 6/18/22.
//

import CoreLocation
import SwiftUI
import WidgetKit

@objc protocol _LSApplicationWorkspace {
	static func defaultWorkspace() -> Self
	func openApplicationWithBundleID(_: String)
}

let LSApplicationWorkspace = unsafeBitCast(NSClassFromString("LSApplicationWorkspace"), to: _LSApplicationWorkspace.Type.self)

@main
struct ComplicatedApp: App {
	@WKApplicationDelegateAdaptor
	var delegate: Delegate
	
	var body: some Scene {
		WindowGroup {
			NavigationStack {
				ContentView()
					.onOpenURL { url in
						let widget = ComplicatedWidgets.allCases.first {
							$0.url == url
						}!
						WidgetCenter.shared.reloadTimelines(ofKind: widget.kind)
						LSApplicationWorkspace.defaultWorkspace().openApplicationWithBundleID(widget.correspondingApp)
					}
			}
		}
	}
}

class Delegate: NSObject, WKApplicationDelegate {
	static let locationManager = CLLocationManager()
	
	func applicationWillEnterForeground() {
		switch Self.locationManager.authorizationStatus {
		case .authorizedAlways, .authorizedWhenInUse:
			break
		default:
			Self.locationManager.requestWhenInUseAuthorization()
		}
	}
}
