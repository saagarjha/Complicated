//
//  Location.swift
//  Complicated Watch App
//
//  Created by Saagar Jha on 6/20/22.
//

import CoreLocation

enum Location {
	@MainActor
	static var current: CLLocation? {
		get async {
			class Delegate: NSObject, CLLocationManagerDelegate {
				var continuation: CheckedContinuation<CLLocation, Error>!

				func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
					continuation.resume(throwing: error)
				}

				func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
					continuation.resume(returning: locations.last!)
				}
			}

			let locationManager = CLLocationManager()
			locationManager.desiredAccuracy = kCLLocationAccuracyReduced

			guard locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways else {
				return nil
			}

			let delegate = Delegate()
			return try? await withCheckedThrowingContinuation { continuation in
				delegate.continuation = continuation
				locationManager.delegate = delegate
				locationManager.requestLocation()
			}
		}
	}
}
