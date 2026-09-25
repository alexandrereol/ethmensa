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

struct ZFVMensaAnswer: Codable {
    let data: ZFVData?
    let errors: [ZFVError]?
}

struct ZFVError: Codable {
    let message: String?
}

struct ZFVData: Codable {
    let outlets: [ZFVOutlet]?
}

struct ZFVOutlet: Codable {
    let externalId, name: String?
    let location: ZFVLocation?
    let calendar: ZFVCalendar?
}

struct ZFVLocation: Codable {
    let address: ZFVAddress?
}

struct ZFVAddress: Codable {
    let addressLine1, zipCode, city: String?
}

struct ZFVCalendar: Codable {
    let week: ZFVCalendarRange?
}

struct ZFVCalendarRange: Codable {
    let daily: [ZFVCalendarDay]?
}

struct ZFVCalendarDay: Codable {
    let date: ZFVDate?
    let menuCategories: [ZFVMenuCategoryDay]?
}

struct ZFVDate: Codable {
    let weekdayNumber: Int?
}

struct ZFVMenuCategoryDay: Codable {
    let category: ZFVMenuCategory?
    let menuItems: [ZFVMenuItem]?
}

struct ZFVMenuCategory: Codable {
    let name, slug: String?
}

struct ZFVMenuItem: Codable {
    let dish: ZFVDish?
    let category: ZFVMenuCategory?
    let prices: [ZFVPrice]?
}

struct ZFVDish: Codable {
    let name, description: String?
    let media: [ZFVDishMedia]?
    let allergens: [ZFVDishAllergen]?
    let isVegan, isVegetarian: Bool?
}

struct ZFVDishMedia: Codable {
    let media: ZFVMedia?
}

struct ZFVMedia: Codable {
    let url: String?
}

struct ZFVDishAllergen: Codable {
    let allergen: ZFVAllergen?
}

struct ZFVAllergen: Codable {
    let externalId, name: String?
}

struct ZFVPrice: Codable {
    let priceCategory: ZFVPriceCategory?
    let amount: String?
}

struct ZFVPriceCategory: Codable {
    let externalId: String?
}
