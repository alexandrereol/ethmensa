//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        openSettingsFor notification: UNNotification?
    ) {
        NavigationManager.shared.sheet = .notificationSettings
    }
}
