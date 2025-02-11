//
//  Copyright © 2022 Alexandre Reol. All rights reserved.
//

import Foundation

struct UZHMensaAnswer: Codable {
    let days: [UZHDay]?
}

struct UZHDay: Codable {
    let dayDate: String?
    let mensa: [UZHMensa]?
}

struct UZHMensa: Codable {
    let mensaId: Int?
    let name, subName, imageUrl, menuTime, menuDayDate: String?
    let currentOpeningTime, address, phone, mail, contact: String?
    let open: [UZHOpen]?
    let menus: [UZHMenu]?
}

struct UZHOpen: Codable {
    let title: String?
    let text: String?
}

struct UZHMenu: Codable {
    let priceStudent, priceEmployee, priceExtern: Double?
    let menuTitle, menuText: String?
    let menuTypes: [String]?
    let ingredients: UZHIngredients?
    let priceExternText, priceEmployeeText, priceStudentText: String?
}

struct UZHIngredients: Codable {
    let allergene, additives: [String]?
    let nutritionalValues: [UZHNutritionalValue]?
}

struct UZHNutritionalValue: Codable {
    let name, value: String?
}
