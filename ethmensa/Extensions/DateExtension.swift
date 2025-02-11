//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
