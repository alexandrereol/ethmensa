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

import SwiftUI

/// An enumeration representing the different types of meat.
enum MeatType {
    /// Represents a beef meal.
    case beef

    /// Represents a chicken meal.
    case chicken

    /// Represents a duck meal.
    case duck

    /// Represents a veal meal.
    case veal

    /// Represents a turkey meal.
    case turkey

    /// Represents a pork meal.
    case pork

    /// Struct with image and color associated.
    struct ImageAndColor: Identifiable {
        let id: String
        let image: Image
        let color: Color
        /// The VoiceOver label of the image, e.g. "Beef".
        let accessibilityLabel: String
    }

    /// The image and color associated with the meal type.
    var imageAndColor: ImageAndColor? {
        switch self {
        case .beef: .init(
            id: "beef",
            image: .init(.beef),
            color: .brown,
            accessibilityLabel: .init(localized: "MEAT_TYPE_BEEF")
        )
        case .chicken: .init(
            id: "chicken",
            image: .init(.chicken),
            color: .yellow,
            accessibilityLabel: .init(localized: "MEAT_TYPE_CHICKEN")
        )
        case .duck: .init(
            id: "duck",
            image: .init(.duck),
            color: .orange,
            accessibilityLabel: .init(localized: "MEAT_TYPE_DUCK")
        )
        case .veal: .init(
            id: "veal",
            image: .init(.beef),
            color: .gray,
            accessibilityLabel: .init(localized: "MEAT_TYPE_VEAL")
        )
        case .turkey: .init(
            id: "turkey",
            image: .init(.turkey),
            color: .brown,
            accessibilityLabel: .init(localized: "MEAT_TYPE_TURKEY")
        )
        case .pork: .init(
            id: "pork",
            image: .init(.pork),
            color: .pink,
            accessibilityLabel: .init(localized: "MEAT_TYPE_PORK")
        )
        }
    }

    /// Get the MealType from the ETH-API provided string.
    static func fromETHString(_ string: String) -> Self? {
        switch string.lowercased() {
        case "beef": .beef
        case "chicken": .chicken
        case "duck": .duck
        case "veal": .veal
        case "turkey": .turkey
        case "pork": .pork
        default: nil
        }
    }
}
