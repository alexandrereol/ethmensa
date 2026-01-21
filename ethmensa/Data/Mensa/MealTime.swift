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

import Foundation

/// Represent a single mealtime with multiple meals
class MealTime: Identifiable {
    /// The unique identifier of the meal
    let id: UUID
    /// The weekday code of the mealtime
    let weekdayCode: Int?
    /// The start time of the mealtime
    let startDateComponents: DateComponents?
    /// The end time of the mealtime
    let endDateComponents: DateComponents?
    /// The type of the mealtime, e.g. "lunch", "dinner"
    let type: String?
    /// The meals of the mealtime
    var meals: [Meal]
    /// The meals that are compatible with the user's allergens if any
    var allergenCompatibleMeals: [Meal] {
        meals.filter { meal in
            Set(meal.allergen ?? [])
                .isDisjoint(
                    with: Set(SettingsManager.shared.allergens)
                )
        }
    }

    init(
        weekdayCode: Int?,
        startDateComponents: DateComponents? = nil,
        endDateComponents: DateComponents? = nil,
        type: String? = nil,
        meals: [Meal] = []
    ) {
        self.id = UUID()
        self.weekdayCode = weekdayCode
        self.startDateComponents = startDateComponents
        self.endDateComponents = endDateComponents
        self.type = type
        self.meals = meals
    }
}

extension MealTime {
    /// An example mealtime for testing purposes
    static let example = MealTime(
        weekdayCode: 0,
        startDateComponents: .fromInt(hour: 11, minute: 00),
        endDateComponents: .fromInt(hour: 13, minute: 30),
        type: "Street",
        meals: .init(repeating: .example, count: 4)
    )
}
