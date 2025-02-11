//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

/// An enumeration representing the different types of meals.
enum MealType {
    /// Represents a vegan meal.
    case vegan

    /// Represents a vegetarian meal.
    case vegetarian

    /// Represents a meal containing fish.
    case fish

    /// Struct with image and color associated.
    struct ImageAndColor: Identifiable {
        let id: String
        let image: Image
        let color: Color
    }

    /// The image and color associated with the meal type.
    var imageAndColor: ImageAndColor? {
        switch self {
        case .vegan: .init(
            id: "vegan",
            image: .init(systemName: "leaf.fill"),
            color: .green
        )
        case .vegetarian: .init(
            id: "vegetarian",
            image: .init(systemName: "leaf"),
            color: .green
        )
        case .fish: .init(
            id: "fish",
            image: .init(systemName: "fish.fill"),
            color: .blue
        )
        }
    }

    /// Get the MealType from the ETH-API provided string.
    static func fromETHString(_ string: String) -> Self? {
        switch string.lowercased() {
        case "vegan": .vegan
        case "vegetarian": .vegetarian
        case "fish": .fish
        default: nil
        }
    }

    /// Get the MealType from the UZH-API provided string.
    static func fromUZHString(_ string: String) -> Self? {
        switch string.lowercased() {
        case "vegan": .vegan
        case "vegetarisch": .vegetarian
        default: nil
        }
    }
}
