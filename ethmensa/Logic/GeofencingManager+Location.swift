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
import Foundation
import os.log
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
        logger.info("\(#function): Entered region with identifier: \(region.identifier)")
        guard region is CLCircularRegion,
              SettingsManager.shared.notifications,
              SettingsManager.shared.location else {
            logger.critical("\(#function): Region is not a circular region or notifications are disabled")
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
        logger.info("\(#function): Exited region with identifier: \(region.identifier)")
        guard region is CLCircularRegion,
              SettingsManager.shared.notifications,
              SettingsManager.shared.location else {
            logger.critical("\(#function): Region is not a circular region or notifications are disabled")
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
        logger.critical("\(#function): failed for region with id \(region!.identifier)")
    }

    internal func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        logger.critical("\(#function): \(error)")
    }
}
