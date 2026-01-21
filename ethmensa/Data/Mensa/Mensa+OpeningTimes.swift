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

extension Mensa {
    /// Represents the opening time of a Mensa.
    enum OpeningTimeState: String {
        /// The Mensa is currently open.
        case open
        /// The Mensa is currently closed.
        case closed
        /// The state of the Mensa is unknown.
        case unknown
    }

    /// Retrieves the current opening times for the Mensa.
    ///
    /// - Returns: An `OpeningTimeState` object representing the current state of the Mensa's opening times.
    func getOpeningTimes() -> OpeningTimeState {
#if !APPCLIP
        guard !SettingsManager.shared.screenshotMode else {
            return .open
        }
#endif
        let mealTimesToday = mealTimes.filter { mealTime in
            mealTime.weekdayCode == (
                Calendar.current.component(
                    .weekday,
                    from: .now
                ) - 1
            )
        }
        for mealTime in mealTimesToday {
            if let startDateComponents = mealTime.startDateComponents,
               let endDateComponents = mealTime.endDateComponents {
                var todayStartDateComponents = Calendar.current.dateComponents(
                    [.hour, .minute, .second, .day, .month, .year],
                    from: .now
                )
                var todayEndDateComponents = Calendar.current.dateComponents(
                    [.hour, .minute, .second, .day, .month, .year],
                    from: .now
                )
                todayStartDateComponents.hour = startDateComponents.hour
                todayStartDateComponents.minute = startDateComponents.minute
                todayEndDateComponents.hour = endDateComponents.hour
                todayEndDateComponents.minute = endDateComponents.minute
                guard let startDate = Calendar.current.date(from: todayStartDateComponents),
                      let endDate = Calendar.current.date(from: todayEndDateComponents) else {
                    return .unknown
                }
                if (startDate...endDate).contains(.now) {
                    return .open
                }
            } else {
                // Should never occur
                return .unknown
            }
        }
        return .closed
    }
}
