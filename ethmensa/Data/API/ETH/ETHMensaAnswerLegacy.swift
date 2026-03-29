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

struct ETHMensaAnswerLegacy: Codable {
    let mensaId: Int
    var name: String
    let location: String?
    let openingTimes, mealTimes: String?
    let web, feedbackUrl: String?
    let meals: [ETHMealLegacy]
    let imageUrl: String?
    let address: String?
    let defaultMensa: Bool?
    let cams: [String]?
}

struct ETHMealLegacy: Codable {
    let type: String?
    let menus: [ETHMenuLegacy]
}

struct ETHMenuLegacy: Codable {
    let menuId: Int
    var title, description: String?
    let price: ETHPriceLegacy
    let origin, allergen: String?
    let mealTypeId: Int?
    let mealType: String?
    let highlightAllergen: Bool?
}

struct ETHPriceLegacy: Codable {
    let student, staff, extern: String?
}
