//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Foundation

extension Calendar {
    static var todayWeedaykETHCorrected: Int {
        let weekday = Calendar(identifier: .gregorian).component(
            .weekday,
            from: .now
        ) - 1
        return weekday == 0 ? 7 : weekday
    }
}
