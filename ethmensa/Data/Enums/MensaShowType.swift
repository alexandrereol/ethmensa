//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

/// Represents the different types of cells in the Mensa view.
enum MensaShowType: String, CaseIterable {
    case all
    case open

    /// The localized string for the enum case.
    var localizedString: String {
        switch self {
        case .all: .init(localized: "OPEN_AND_CLOSED")
        case .open: .init(localized: "OPEN")
        }
    }
}
