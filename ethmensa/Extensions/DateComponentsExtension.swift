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
