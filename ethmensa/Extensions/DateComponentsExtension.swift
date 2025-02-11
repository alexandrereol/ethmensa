//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Foundation

extension DateComponents {
    static func fromStringSeparatedByColon(string: String) -> DateComponents? {
        if let date = DateFormatter.hourMinuteSeparatedByColon.date(from: string) {
            fromInt(
                hour: Calendar.current.component(.hour, from: date),
                minute: Calendar.current.component(.minute, from: date)
            )
        } else {
            nil
        }
    }

    static func fromInt(hour: Int, minute: Int) -> DateComponents? {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        return components
    }
}
