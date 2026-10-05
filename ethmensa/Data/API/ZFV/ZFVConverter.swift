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

    static func convert(outlets: [ZFVOutlet], infos: [String: ZFVOutletInfo]) -> [Mensa] {
        outlets.compactMap { outlet in
            convertOutlet(outlet, info: outlet.externalId.flatMap { infos[$0] })
        }
    }

    private static func convertOutlet(
        _ outlet: ZFVOutlet,
        info: ZFVOutletInfo?
    ) -> Mensa? {
        guard let name = outlet.name,
              let externalIdStr = outlet.externalId,
              let externalID = Int(externalIdStr) else {
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
        let mealTimes = buildMealTimes(from: outlet.calendar?.week?.daily, info: info)
        // Leaves out outlets without dishes this week, such as the cafés and shops
        guard !mealTimes.isEmpty else {
            return nil
        }
        return Mensa(
            provider: .uzh,
            facilityID: info?.uzhID ?? externalID,
            name: info?.name ?? name,
            location: locationStr.isEmpty ? info?.address : locationStr,
            webURL: nil,
            imageURL: info?.imageURL,
            mealTimes: mealTimes
        )
    }

    private static func buildMealTimes(
        from dailyEntries: [ZFVCalendarDay]?,
        info: ZFVOutletInfo?
    ) -> [MealTime] {
        guard let dailyEntries else {
            return []
        }

        var mealTimes: [MealTime] = []
        for daily in dailyEntries {
            mealTimes.append(contentsOf: buildMealTimes(from: daily, info: info))
        }
        return mealTimes
    }

    private static func buildMealTimes(
        from daily: ZFVCalendarDay,
        info: ZFVOutletInfo?
    ) -> [MealTime] {
        guard let weekdayCode = daily.date?.weekdayNumber else {
            logger.critical("\(#function): Could not parse weekday")
            return []
        }

        return daily.menuCategories?
            // Lists lunch before dinner, which the API does not always do
            .sorted { lhs, rhs in
                ServiceTime.rank(of: lhs.category?.slug) < ServiceTime.rank(of: rhs.category?.slug)
            }
            .compactMap { category in
                buildMealTime(from: category, weekdayCode: weekdayCode, info: info)
            } ?? []
    }

    private static func buildMealTime(
        from category: ZFVMenuCategoryDay,
        weekdayCode: Int,
        info: ZFVOutletInfo?
    ) -> MealTime? {
        let meals = category.menuItems?.compactMap { item in
            buildMeal(from: item)
        } ?? []

        guard !meals.isEmpty else {
            return nil
        }

        let serviceTime = ServiceTime(slug: category.category?.slug)
        let hours = serviceTime.flatMap { info?.hours(for: $0) }
        return MealTime(
            weekdayCode: weekdayCode,
            startDateComponents: hours.flatMap { .fromStringSeparatedByColon(string: $0.start) },
            endDateComponents: hours.flatMap { .fromStringSeparatedByColon(string: $0.end) },
            type: serviceTime?.localizedString ?? category.category?.name,
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
        let prices = dishItem.prices ?? []
        let student = prices.first { $0.priceCategory?.externalId == "1" }?.amount.flatMap(Double.init)
        let staff = prices.first { $0.priceCategory?.externalId == "2" }?.amount.flatMap(Double.init)
        let extern = prices.first { $0.priceCategory?.externalId == "3" }?.amount.flatMap(Double.init)
        // Some dishes, such as the daily pasta, come with no prices or prices of 0
        let hasPrice = [student, staff, extern].contains { ($0 ?? 0) > 0 }
        let price = hasPrice ? Price(student: student, staff: staff, extern: extern) : nil
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
        // Some dishes have an empty name and description, only their menu line tells what they are
        return Meal(
            title: dishItem.category?.name,
            name: dish.name?.isEmpty == false ? dish.name : nil,
            description: dish.description?.isEmpty == false ? dish.description : nil,
            imageURL: dish.media?.first?.media?.url?.toURL(),
            price: price,
            mealType: mealTypes.isEmpty ? nil : mealTypes,
            allergen: allergens?.isEmpty == true ? nil : allergens
        )
    }
}

extension ZFVConverter {
    /// The meal time a menu category is served at. The API names the categories inconsistently,
    /// e.g. "Mittagsverpflegung", "Lunch" or "Abend", so they are told apart by their slug.
    enum ServiceTime {
        case lunch
        case dinner

        init?(slug: String?) {
            guard let slug else {
                return nil
            }
            if slug.contains("abend") || slug.contains("dinner") {
                self = .dinner
            } else if slug.contains("mittag") || slug.contains("lunch") {
                self = .lunch
            } else {
                return nil
            }
        }

        /// The position of a menu category in the day: lunch first, dinner last and other categories in between.
        static func rank(of slug: String?) -> Int {
            switch ServiceTime(slug: slug) {
            case .lunch: 0
            case nil: 1
            case .dinner: 2
            }
        }

        var localizedString: String {
            switch self {
            case .lunch: .init(localized: "LUNCH")
            case .dinner: .init(localized: "DINNER")
            }
        }
    }
}
