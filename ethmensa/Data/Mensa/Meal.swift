//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import CoreTransferable
import Foundation

/// Represent a single meal
class Meal: Identifiable {
    /// The unique identifier of the meal
    let id: UUID
    /// The title of the meal
    var title: String?
    /// The name of the meal
    var name: String?
    /// The description of the meal
    var description: String?
    /// The image URL of the meal
    let imageURL: URL?
    /// The price of the meal
    let price: Price?
    /// The meal types of the meal
    let mealType: [MealType]?
    /// The meat types of the meal
    let meatType: [MeatType]?
    /// The allergens of the meal
    let allergen: [Allergen]?

    init(
        title: String? = nil,
        name: String? = nil,
        description: String? = nil,
        imageURL: URL? = nil,
        price: Price? = nil,
        mealType: [MealType]? = nil,
        meatType: [MeatType]? = nil,
        allergen: [Allergen]? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.price = price
        self.mealType = mealType
        self.meatType = meatType
        self.allergen = allergen
    }
}

extension Meal: Transferable {
    /// The summary of the meal used when copying the meal to the clipboard
    var summary: String {
        [title, name, description].compactMap { $0 }.joined(separator: "\n")
    }

    /// The transfer representation of the meal
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.summary)
    }
}

extension Meal {
    /// An example meal for testing purposes
    static let example = Meal(
        title: "Example Meal",
        name: "Some good food",
        description: "Some very good ingredients prepared with love",
        // swiftlint:disable:next line_length
        imageURL: .init(string: "https://images.squarespace-cdn.com/content/v1/5b5aa0922487fd1ce32c117a/1547765015801-FSR1DVSKCZU3PAYWIRQG/broccoli.jpg"),
        price: .example,
        mealType: [
            .vegetarian
        ],
        meatType: [
            .beef,
            .pork
        ],
        allergen: [
            .gluten,
            .eggs
        ]
    )
}
