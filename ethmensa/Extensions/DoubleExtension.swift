//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Foundation

extension Double {
    /// Converts the Double value to a formatted string representing Swiss Francs (CHF).
    ///
    /// - Returns: A string formatted to two decimal places. If the value is 0, returns "NaN".
    func toCHFstring() -> String {
        if self == 0 {
            "NaN"
        } else {
            .init(format: "%.2f", self)
        }
    }
}
