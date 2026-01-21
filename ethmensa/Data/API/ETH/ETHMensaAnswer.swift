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

struct ETHMensaAnswer: Codable {
    let weeklyRotaArray: [ETHWeeklyRotaArray]?

    private enum CodingKeys: String, CodingKey {
        case weeklyRotaArray = "weekly-rota-array"
    }
}

struct ETHWeeklyRotaArray: Codable {
    let weeklyRotaID: Int?
    let facilityID: Int?
    let validFrom: String?
    let validTo: String?
    let dayOfWeekArray: [ETHDayOfWeekArray]?

    private enum CodingKeys: String, CodingKey {
        case weeklyRotaID = "weekly-rota-array"
        case facilityID = "facility-id"
        case validFrom = "valid-from"
        case validTo = "valid-to"
        case dayOfWeekArray = "day-of-week-array"
    }
}

extension ETHWeeklyRotaArray {
    var isValidToday: Bool {
        guard let validFromDate = DateFormatter.getETHIDApps.date(
            from: validFrom ?? ""
        ),
              let validToDate = DateFormatter.getETHIDApps.date(
                // ETH has forgotten to provide a "valid-to" in the past, so default to 2099-12-31
                from: validTo ?? "2099-12-31"
              ),
              let validToDate = Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: validToDate
              ) else {
            return false
        }
        return (validFromDate...validToDate).contains(Date.now)
    }
}

struct ETHDayOfWeekArray: Codable {
    let dayOfWeekCode: Int?
    let dayOfWeekDesc: String?
    let dayOfWeekDescShort: String?
    let openingHourArray: [ETHOpeningHourArray]?

    private enum CodingKeys: String, CodingKey {
        case dayOfWeekCode = "day-of-week-code"
        case dayOfWeekDesc = "day-of-week-desc"
        case dayOfWeekDescShort = "day-of-week-desc-short"
        case openingHourArray = "opening-hour-array"
    }
}

struct ETHOpeningHourArray: Codable {
    let timeFrom: String?
    let timeTo: String?
    let mealTimeArray: [ETHMealTimeArray]?

    private enum CodingKeys: String, CodingKey {
        case timeFrom = "time-from"
        case timeTo = "time-to"
        case mealTimeArray = "meal-time-array"
    }
}

struct ETHMealTimeArray: Codable {
    let name: String?
    let timeFrom: String?
    let timeTo: String?
    let lineArray: [ETHLineArray]?
    let menu: ETHMensaMenu?

    private enum CodingKeys: String, CodingKey {
        case name, menu
        case timeFrom = "time-from"
        case timeTo = "time-to"
        case lineArray = "line-array"
    }
}

extension ETHMealTimeArray: Comparable {
    static func < (lhs: ETHMealTimeArray, rhs: ETHMealTimeArray) -> Bool {
        if let lhsTime = lhs.timeFrom,
           let rhsTime = rhs.timeFrom {
            lhsTime < rhsTime
        } else {
            true
        }
    }

    static func == (lhs: ETHMealTimeArray, rhs: ETHMealTimeArray) -> Bool {
        lhs.name ?? "" == rhs.name ?? ""
    }
}

struct ETHLineArray: Codable {
    let name: String?
    let meal: ETHMensaAnswerMeal?
}

struct ETHMensaAnswerMeal: Codable {
    let lineID: Int?
    let name: String?
    let description: String?
    let priceUnitCode: Int?
    let priceUnitDesc: String?
    let priceUnitDescShort: String?
    let mealPriceArray: [ETHPriceArray]?
    let mealClassArray: [ETHAdditionalInfo]?
    let allergenArray: [ETHAdditionalInfo]?
    let meatTypeArray: [ETHAdditionalInfo]?
    let imageURL: String?
    //    let fishingMethodArray: [ETHAdditionalInfo]?
    //    let energy: Double?
    //    let proteins: Double?
    //    let fat: Double?
    //    let carbohydrates: Double?
    //    let addonArray: [ETHAddonArray]?

    private enum CodingKeys: String, CodingKey {
        case name, description
        //        case energy, proteins, fat, carbohydrates
        case lineID = "line-id"
        case priceUnitCode = "price-unit-code"
        case priceUnitDesc = "price-unit-desc"
        case priceUnitDescShort = "price-unit-desc-short"
        case mealPriceArray = "meal-price-array"
        case mealClassArray = "meal-class-array"
        case allergenArray = "allergen-array"
        case meatTypeArray = "meat-type-array"
        case imageURL = "image-url"
        //        case fishingMethodArray = "fishing-method-array"
        //        case addonArray = "addon-array"
    }
}

// struct ETHAddonArray: Codable {
//    let name: String?
//    let priceUnitCode: Int?
//    let priceUnitDesc: String?
//    let priceUnitDescShort: String?
//    let priceArray: [ETHPriceArray]?
// }

struct ETHPriceArray: Codable {
    let price: Double?
    //    let customerGroupCode: Int?
    //    let customerGroupPosition: Int?
    //    let customerGroupDesc: String?
    //    let customerGroupDescShort: String?
}

struct ETHAdditionalInfo: Codable {
    let code: Int?
    //    let position: Int?
    //    let descShort: String?
    let desc: String?
    //    let originArray: [ETHAdditionalInfo]?
}

struct ETHMensaMenu: Codable {
    let menuURL: String?

    private enum CodingKeys: String, CodingKey {
        case menuURL = "menu-url"
    }
}
