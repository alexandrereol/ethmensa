//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Foundation

/// Represents the price of a meal.
class Price: Identifiable {
    /// The unique identifier of the price.
    var id: UUID
    /// The price for students.
    let student: Double?
    /// The price for staff.
    let staff: Double?
    /// The price for external customers.
    let extern: Double?
    /// The currency string.
    private let currencyString = " CHF"

    init(
        student: Double? = nil,
        staff: Double? = nil,
        extern: Double? = nil
    ) {
        self.id = UUID()
        self.student = student
        self.staff = staff
        self.extern = extern
    }

    /// Returns the price as a string according to user settings.
    func getString() -> String {
        let fullString = [
            (student ?? 0).toCHFstring(),
            (staff ?? 0).toCHFstring(),
            (extern ?? 0).toCHFstring()
        ].joined(separator: "/") + currencyString
#if !APPCLIP
        return switch SettingsManager.shared.priceType {
        case .all: fullString
        case .student: ([student, staff, extern].compactMap { $0 }.first?.toCHFstring() ?? "NaN") + currencyString
        case .staff: ([staff, extern].compactMap { $0 }.first?.toCHFstring() ?? "NaN") + currencyString
        case .external: (extern?.toCHFstring() ?? "NaN") + currencyString
        }
#else
        return fullString
#endif
    }
}

extension Price {
    /// An example price for testing purposes.
    static let example = Price(
        student: 6.00,
        staff: 9.00,
        extern: 12.00
    )
}
