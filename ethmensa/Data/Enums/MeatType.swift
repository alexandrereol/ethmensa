//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
    }

    /// The image and color associated with the meal type.
    var imageAndColor: ImageAndColor? {
        switch self {
        case .beef: .init(
            id: "beef",
            image: .init(.beef),
            color: .brown
        )
        case .chicken: .init(
            id: "chicken",
            image: .init(.chicken),
            color: .yellow
        )
        case .duck: .init(
            id: "duck",
            image: .init(.duck),
            color: .orange
        )
        case .veal: .init(
            id: "veal",
            image: .init(.beef),
            color: .gray
        )
        case .turkey: .init(
            id: "turkey",
            image: .init(.turkey),
            color: .brown
        )
        case .pork: .init(
            id: "pork",
            image: .init(.pork),
            color: .pink
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
