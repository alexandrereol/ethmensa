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

    private static let zurichTimeZone = TimeZone(identifier: "Europe/Zurich") ?? .current

    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    static func convert(data: ZFVGraph.MensasQuery.Data) -> [Mensa] {
        data.outlets.compactMap { convertOutlet($0) }
    }

    private static func convertOutlet(
        _ outlet: ZFVGraph.MensasQuery.Data.Outlet
    ) -> Mensa? {
        guard let externalIdStr = outlet.externalId,
              let facilityID = Int(externalIdStr) else {
            logger.critical(
                "\(#function): Missing or invalid externalId for outlet \(outlet.id)"
            )
            return nil
        }
        let locationStr = [
            outlet.location?.address?.city,
            outlet.location?.address?.zipCode
        ].compactMap { $0 }.joined(separator: " ")
        let mealTimes = buildMealTimes(from: outlet.menuItems)
        return Mensa(
            provider: .zfv,
            facilityID: facilityID,
            name: outlet.name,
            location: locationStr.isEmpty ? nil : locationStr,
            webURL: nil,
            imageURL: outlet.logoUrl.flatMap { URL(string: $0) },
            mealTimes: mealTimes
        )
    }

    private static func buildMealTimes(
        from items: [ZFVGraph.MensasQuery.Data.Outlet.MenuItem]
    ) -> [MealTime] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = zurichTimeZone

        var groups: [String: [ZFVGraph.MensasQuery.Data.Outlet.MenuItem]] = [:]
        for item in items {
            guard let validFromStr = item.validFrom?.dateUtc,
                  let validFromDate = isoFormatter.date(from: validFromStr) else {
                continue
            }
            let comps = calendar.dateComponents([.year, .month, .day, .hour], from: validFromDate)
            let hour = comps.hour ?? 0
            let period = hour < 14 ? "LUNCH" : "DINNER"
            let key = String(
                format: "%04d-%02d-%02d/%@",
                comps.year ?? 0,
                comps.month ?? 0,
                comps.day ?? 0,
                period
            )
            groups[key, default: []].append(item)
        }

        return groups.compactMap { key, groupItems in
            buildMealTime(key: key, items: groupItems, calendar: calendar)
        }.sorted {
            if $0.weekdayCode != $1.weekdayCode {
                return ($0.weekdayCode ?? 0) < ($1.weekdayCode ?? 0)
            }
            // DINNER sorts after LUNCH alphabetically — reverse to put LUNCH first
            return ($0.type ?? "") < ($1.type ?? "")
        }
    }

    private static func buildMealTime(
        key: String,
        items: [ZFVGraph.MensasQuery.Data.Outlet.MenuItem],
        calendar: Calendar
    ) -> MealTime? {
        guard let firstItem = items.first,
              let validFromStr = firstItem.validFrom?.dateUtc,
              let validToStr = firstItem.validTo?.dateUtc,
              let validFromDate = isoFormatter.date(from: validFromStr),
              let validToDate = isoFormatter.date(from: validToStr) else {
            return nil
        }
        let period = key.components(separatedBy: "/").last ?? "LUNCH"
        let weekdayCode = calendar.component(.weekday, from: validFromDate) - 1
        let startComponents = calendar.dateComponents([.hour, .minute], from: validFromDate)
        let endComponents = calendar.dateComponents([.hour, .minute], from: validToDate)
        let meals = items.compactMap { buildMeal(from: $0) }
        guard !meals.isEmpty else {
            return nil
        }
        return MealTime(
            weekdayCode: weekdayCode,
            startDateComponents: startComponents,
            endDateComponents: endComponents,
            type: period,
            meals: meals
        )
    }

    private static func buildMeal(
        from item: ZFVGraph.MensasQuery.Data.Outlet.MenuItem
    ) -> Meal? {
        guard let dishFragment = item.asOutletMenuItemDish,
              let dish = dishFragment.dish else {
            return nil
        }
        let student = item.prices.first.flatMap { Double($0.amount) }
        let staff = item.prices.count > 1 ? Double(item.prices[1].amount) : nil
        let extern = item.prices.count > 2 ? Double(item.prices[2].amount) : nil
        let price = Price(student: student, staff: staff, extern: extern)
        var mealTypes: [MealType] = []
        if dish.isVegan {
            mealTypes.append(.vegan)
        } else if dish.isVegetarian {
            mealTypes.append(.vegetarian)
        }
        let allergens = dish.allergens.compactMap { relation in
            Allergen.fromZFVString(relation.allergen.name)
        }
        return Meal(
            title: item.label,
            name: dish.name,
            description: nil,
            imageURL: dish.imageUrl.flatMap { URL(string: $0) },
            price: price,
            mealType: mealTypes.isEmpty ? nil : mealTypes,
            allergen: allergens.isEmpty ? nil : allergens
        )
    }
}
