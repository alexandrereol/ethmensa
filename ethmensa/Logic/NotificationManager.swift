//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import os.log
import UserNotifications

/// Responsible for scheduling, delivery, and management of user notifications.
class NotificationManager {
    //// A singleton instance of `NotificationManager` to manage mensa data.
    ///
    /// Use `NotificationManager.shared` to access the shared instance.
    static let shared = NotificationManager()

    /// A logger instance for the `NotificationManager` class.
    ///
    /// This logger is initialized with the app's bundle identifier as the subsystem
    /// and the name of the `NotificationManager` class as the category. It is used to
    /// log messages related to the operations and events within the NotificationManager.
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: NotificationManager.self)
    )

    /// The notification center used to manage and handle user notifications.
    private let notificationCenter = UNUserNotificationCenter.current()

    /// Generates and schedules notifications for the current week's weekdays.
    /// 
    /// This function performs the following steps:
    /// 1. Removes any existing notifications with identifiers ranging from 0 to 7.
    /// 2. Creates a new notification content with a localized body, time-sensitive interruption level, and current
    ///   sound settings.
    /// 3. Sets up date components with the current calendar and the notification time from `SettingsManager`.
    /// 4. Iterates over the weekdays from the first weekday of the current calendar to the next four weekdays.
    /// 5. For each weekday, creates a notification trigger and request, and adds it to the notification center.
    /// 
    /// If an error occurs while adding a notification request, it logs the error using the logger.
    func generateNotif() {
        removeNotifications(
            withIdentifiers: (0...7).map {
                String.notificationRequestPeriodicPrefix.appending(String($0))
            }
        )
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = .init(localized: "CHECK_OUT_TODAYS_MENSA_MENU!")
        notificationContent.interruptionLevel = .timeSensitive
        notificationContent.sound = Sound.current

        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = SettingsManager.shared.notificationsTime.hour
        dateComponents.minute = SettingsManager.shared.notificationsTime.minute

        let firstWeekday = Calendar.current.firstWeekday
        for index in firstWeekday...(firstWeekday+4) {
            dateComponents.weekday = index
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: true
            )
            let request = UNNotificationRequest(
                identifier: .notificationRequestPeriodicPrefix.appending(String(index)),
                content: notificationContent,
                trigger: trigger
            )
            notificationCenter.add(request) { error in
                if let error = error {
                    self.logger.critical("generateNotif(): \(error)")
                }
            }
        }
    }

    /// Removes notifications with the specified identifiers from both delivered and pending notifications.
    ///
    /// - Parameter identifiers: An array of strings representing the identifiers of the notifications to be removed.
    func removeNotifications(withIdentifiers identifiers: [String]) {
        notificationCenter.removeDeliveredNotifications(
            withIdentifiers: identifiers
        )
        notificationCenter.removePendingNotificationRequests(
            withIdentifiers: identifiers
        )
    }
}
