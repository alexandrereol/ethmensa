//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

/// Represents the different types of sorting in the Mensa.
enum SortType: String, CaseIterable {
    case def
    case name

    /// The localized string for the enum.
    var localizedString: String {
        switch self {
        case .def: .init(localized: "SMART_SORTING")
        case .name: .init(localized: "SORTING_BY_NAME")
        }
    }
}
