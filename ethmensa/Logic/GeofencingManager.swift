//
//  Copyright © 2026 Alexandre Reol
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <https://www.gnu.org/licenses/>.
//

import CoreLocation
import os.log

/// Handles setup, monitoring, and processing of geofencing events.
///
/// - Important: Using geofencing around CLCircularRegion is not reliable, consider making the feature iOS 17.0+
///   in the future and use CLMonitor instead: https://developer.apple.com/documentation/corelocation/clmonitor
class GeofencingManager: NSObject {
    /// A singleton instance of `GeofencingManager`.
    ///
    /// Use this shared instance to access geofencing functionalities throughout the app.
    static let shared = GeofencingManager()

    /// A logger instance for the `GeofencingManager` class.
    ///
    /// This logger is initialized with the app's bundle identifier as the subsystem
    /// and the name of the `GeofencingManager` class as the category. It is used to
    /// log messages related to geofencing operations within the app.
    internal let logger = Logger(
        subsystem: Bundle.main.safeIdentifier,
        category: String(describing: GeofencingManager.self)
    )

    /// The location manager responsible for handling geofencing-related location updates and permissions.
    private var locationManager = CLLocationManager()

    /// A lazy property that initializes an array of `CLCircularRegion` objects representing geofences for all campuses.
    /// - Returns: An array of `CLCircularRegion` objects.
    lazy private var geofences: [CLCircularRegion] = {
        Campus.allCampuses.map { campus in
            makeGeoRegion(
                long: campus.location.coordinate.longitude,
                lat: campus.location.coordinate.latitude,
                identifier: campus.type.rawValue
            )
        }
    }()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    /// Creates a geofencing region with the specified coordinates and identifier.
    ///
    /// - Parameters:
    ///   - long: The longitude of the center of the region.
    ///   - lat: The latitude of the center of the region.
    ///   - identifier: A unique identifier for the region.
    /// - Returns: A `CLCircularRegion` object configured with the specified parameters and a radius of 500 meters.
    private func makeGeoRegion(
        long: Double,
        lat: Double,
        identifier: String
    ) -> CLCircularRegion {
        let geofenceRegion = CLCircularRegion(
            center: CLLocationCoordinate2DMake(long, lat),
            radius: 500,
            identifier: identifier
        )
        geofenceRegion.notifyOnExit = true
        geofenceRegion.notifyOnEntry = true
        return geofenceRegion
    }

    /// Starts the geofencing manager by initiating monitoring for all defined geofences.
    ///
    /// This method logs the start of the geofencing manager and iterates through the list of geofences,
    /// instructing the location manager to start monitoring each one.
    func startGeofencingManager() {
        logger.info(#function)
        geofences.forEach {
            locationManager.startMonitoring(for: $0)
        }
    }

    /// Stops the geofencing manager and stops monitoring all geofences.
    ///
    /// This method logs an informational message indicating that the geofencing manager is stopping.
    /// It then iterates through all monitored geofences and stops monitoring each one using the location manager.
    func stopGeofencingManager() {
        logger.info(#function)
        geofences.forEach {
            locationManager.stopMonitoring(for: $0)
        }
    }
}
