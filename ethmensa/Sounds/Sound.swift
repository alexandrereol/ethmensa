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

import UserNotifications

/// The `Sound` struct is used to encapsulate properties and behaviors related to a notification sound object.
struct Sound: Identifiable {
    /// A unique identifier for the sound.
    let id: String

    /// The localized name of the sound.
    let localizedName: String

    /// The notification sound.
    let notificationSound: UNNotificationSound?

    /// A computed property that returns the current notification sound based on the user's settings.
    /// - Returns: The `UNNotificationSound` object corresponding to the selected sound in the user's settings,
    /// or `nil` if the selected sound is the first sound in the list.
    static var current: UNNotificationSound? {
        if SettingsManager.shared.notificationsSound == all.first?.id {
            nil
        } else {
            all.first {
                $0.id == SettingsManager.shared.notificationsSound
            }?.notificationSound
        }
    }

    /// A static property that returns an array of `Sound` objects.
    /// 
    /// - Returns: An array of `Sound` objects with predefined values.
    static var all: [Sound] {
        [
            .init(
                id: "default-apple",
                localizedName: "\(OperatingSystemType.getCurrent.rawValue) \(String(localized: "DEFAULT"))",
                notificationSound: nil
            ),
            .init(
                id: "default",
                localizedName: .init(localized: "DEFAULT"),
                notificationSound: .init(named: .init(rawValue: "default.mp3"))
            ),
            .init(
                id: "click",
                localizedName: "Click",
                notificationSound: .init(named: .init(rawValue: "click.mp3"))
            )
        ]
    }
}
