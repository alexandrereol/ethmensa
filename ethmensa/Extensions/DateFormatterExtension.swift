//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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

    /// Initializes a `DateFormatter` with the specified date format string.
    ///
    /// - Parameter dateFormat: A string representing the desired date format.
    convenience init(_ dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}
