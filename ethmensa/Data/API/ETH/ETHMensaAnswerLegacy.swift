//
//  Copyright © 2022 Alexandre Reol. All rights reserved.
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
