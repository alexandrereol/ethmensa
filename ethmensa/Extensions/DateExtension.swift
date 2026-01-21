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

extension Date {
    static func fromInt(hour: Int, minute: Int) -> Date? {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        return if let date = Calendar.current.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: Date.now
        ) {
            date
        } else {
            nil
        }
    }

    var hour: Int {
        let components = Calendar.current.dateComponents(
            [.hour],
            from: self
        )
        return components.hour ?? 0
    }

    var minute: Int {
        let components = Calendar.current.dateComponents(
            [.minute],
            from: self
        )
        return components.minute ?? 0
    }

    static var weekdaysStartingAtOne: [(index: Int, string: String)] {
        var days = Calendar.current.weekdaySymbols
        days.append(days.remove(at: 0))
        return days.enumerated().map { (dayCode, dayString) in
            (dayCode + 1, dayString)
        }
    }
}
