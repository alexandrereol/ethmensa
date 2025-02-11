//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import os.log
import Foundation
import CoreLocation
import UserNotifications

extension GeofencingManager: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) { }

    func locationManager(
        _ manager: CLLocationManager,
        didEnterRegion region: CLRegion
    ) {
        logger.info("Entered region with identifier: \(region.identifier)")
        guard region is CLCircularRegion,
              SettingsManager.shared.notifications,
              SettingsManager.shared.location else {
            logger.critical("Region is not a circular region or notifications are disabled")
            return
        }
        if Campus.CampusType.allCases.map(\.rawValue).contains(
            region.identifier
        ) {
            NotificationManager.shared.generateNotif()
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didExitRegion region: CLRegion
    ) {
        logger.info("Exited region with identifier: \(region.identifier)")
        guard region is CLCircularRegion,
              SettingsManager.shared.notifications,
              SettingsManager.shared.location else {
            logger.critical("Region is not a circular region or notifications are disabled")
            return
        }
        if Campus.CampusType.allCases.map(\.rawValue).contains(region.identifier) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }

    internal func locationManager(
        _ manager: CLLocationManager,
        monitoringDidFailFor region: CLRegion?,
        withError error: Error
    ) {
        logger.critical("Monitoring failed for region with identifier: \(region!.identifier)")
    }

    internal func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        logger.critical("Location Manager failed with the following error: \(error)")
    }
}
