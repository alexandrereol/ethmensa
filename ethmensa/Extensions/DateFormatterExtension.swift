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

import Foundation

extension DateFormatter {
    /// A `DateFormatter` configured to display time in "HH:mm" format.
    ///
    /// - Returns: A `DateFormatter` instance with the format "HH:mm".
    static var hourMinuteSeparatedByColon: DateFormatter {
        DateFormatter("HH:mm")
    }

    /// A computed property that returns a `DateFormatter` configured with the "yyyy-MM-dd" date format.
    /// 
    /// - Returns: A `DateFormatter` instance compatible with the ETH ID Apps endpoint.
    static var getETHIDApps: DateFormatter {
        DateFormatter("yyyy-MM-dd")
    }

    /// Initializes a fixed-format `DateFormatter` for API values with the specified date format string.
    ///
    /// The formatter uses the `en_US_POSIX` locale and the Gregorian calendar in the Europe/Zurich time zone
    /// (`Calendar.api`), so API dates and times are parsed and formatted the same way regardless of the user's
    /// calendar, locale, digits or 12/24-hour preference.
    ///
    /// - Parameter dateFormat: A string representing the desired date format.
    convenience init(_ dateFormat: String) {
        self.init()
        self.locale = Locale(identifier: "en_US_POSIX")
        self.calendar = .api
        self.timeZone = Calendar.api.timeZone
        self.dateFormat = dateFormat
    }
}

extension Calendar {
    /// The Gregorian calendar in the Europe/Zurich time zone, used for fixed-format API dates and times.
    static var api: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(identifier: "Europe/Zurich") ?? .current
        return calendar
    }
}
