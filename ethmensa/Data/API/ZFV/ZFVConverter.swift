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
import os.log

struct ZFVConverter {
    private static let logger = Logger(
        subsystem: Bundle.main.safeIdentifier,
        category: String(describing: ZFVConverter.self)
    )

    static func convert(outlets: [ZFVOutlet]) -> [Mensa] {
        outlets.compactMap { convertOutlet($0) }
    }

    private static func convertOutlet(
        _ outlet: ZFVOutlet
    ) -> Mensa? {
        guard let name = outlet.name,
              let externalIdStr = outlet.externalId,
              let facilityID = Int(externalIdStr) else {
            logger.critical(
                "\(#function): Missing or invalid externalId for outlet \(outlet.name ?? "unknown")"
            )
            return nil
        }
        let street = outlet.location?.address?.addressLine1
        let cityLine = [
            outlet.location?.address?.zipCode,
            outlet.location?.address?.city
        ].compactMap { $0 }.joined(separator: " ")
        let locationStr = [
            street,
            cityLine.isEmpty ? nil : cityLine
        ].compactMap { $0 }.joined(separator: "\n")
        let mealTimes = buildMealTimes(from: outlet.calendar?.week?.daily)
        // Leaves out outlets without dishes this week, such as the cafés and shops
        guard !mealTimes.isEmpty else {
            return nil
        }
        return Mensa(
            provider: .zfv,
            facilityID: facilityID,
            name: name,
            location: locationStr.isEmpty ? nil : locationStr,
            webURL: nil,
            imageURL: nil,
            mealTimes: mealTimes
        )
    }

    private static func buildMealTimes(
        from dailyEntries: [ZFVCalendarDay]?
    ) -> [MealTime] {
        guard let dailyEntries else {
            return []
        }

        var mealTimes: [MealTime] = []
        for daily in dailyEntries {
            mealTimes.append(contentsOf: buildMealTimes(from: daily))
        }
        return mealTimes
    }

    private static func buildMealTimes(
        from daily: ZFVCalendarDay
    ) -> [MealTime] {
        guard let weekdayCode = daily.date?.weekdayNumber else {
            logger.critical("\(#function): Could not parse weekday")
            return []
        }

        return daily.menuCategories?.compactMap { category in
            buildMealTime(from: category, weekdayCode: weekdayCode)
        } ?? []
    }

    private static func buildMealTime(
        from category: ZFVMenuCategoryDay,
        weekdayCode: Int
    ) -> MealTime? {
        let meals = category.menuItems?.compactMap { item in
            buildMeal(from: item)
        } ?? []

        guard !meals.isEmpty else {
            return nil
        }

        return MealTime(
            weekdayCode: weekdayCode,
            type: category.category?.name,
            meals: meals
        )
    }

    private static func buildMeal(
        from dishItem: ZFVMenuItem
    ) -> Meal? {
        // Menu items other than dishes come without a dish and are skipped
        guard let dish = dishItem.dish else {
            return nil
        }
        guard let dishName = dish.name else {
            logger.critical("\(#function): Could not get dish name")
            return nil
        }
        let prices = dishItem.prices ?? []
        let student = prices.first { $0.priceCategory?.externalId == "1" }?.amount.flatMap(Double.init)
        let staff = prices.first { $0.priceCategory?.externalId == "2" }?.amount.flatMap(Double.init)
        let extern = prices.first { $0.priceCategory?.externalId == "3" }?.amount.flatMap(Double.init)
        let price = Price(student: student, staff: staff, extern: extern)
        var mealTypes: [MealType] = []
        if dish.isVegan == true {
            mealTypes.append(.vegan)
        } else if dish.isVegetarian == true {
            mealTypes.append(.vegetarian)
        }
        let allergens: [Allergen]? = dish.allergens?.flatMap { wrapper -> [Allergen] in
            guard let externalID = wrapper.allergen?.externalId else {
                return []
            }
            return Allergen.fromZFV(id: externalID, name: wrapper.allergen?.name)
        }.unique
        return Meal(
            title: dishItem.category?.name,
            name: nil,
            description: dishName,
            imageURL: dish.imageUrl?.toURL(),
            price: price,
            mealType: mealTypes.isEmpty ? nil : mealTypes,
            allergen: allergens?.isEmpty == true ? nil : allergens
        )
    }
}
