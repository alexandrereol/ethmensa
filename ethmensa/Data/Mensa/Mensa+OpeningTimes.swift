//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
