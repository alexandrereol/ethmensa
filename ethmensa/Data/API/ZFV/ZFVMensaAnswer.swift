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

struct ZFVGraphQLResponse<T: Decodable>: Decodable {
    let data: T?
}

struct ZFVOutletsData: Decodable {
    let outlets: [ZFVOutlet]
}

struct ZFVOutlet: Decodable {
    let id: String
    let name: String
    let logoUrl: String?
    let location: ZFVLocation?
    let externalId: String?
    let menuItems: [ZFVMenuItem]
}

struct ZFVLocation: Decodable {
    let id: String
    let name: String
    let address: ZFVAddress?
}

struct ZFVAddress: Decodable {
    let id: String
    let zipCode: String?
    let city: String?
}

struct ZFVMenuItem: Decodable {
    let id: String
    let type: String?
    let label: String?
    let validFrom: ZFVDateWithTimezone?
    let validTo: ZFVDateWithTimezone?
    let prices: [ZFVPrice]
    let dish: ZFVDish?
}

struct ZFVDateWithTimezone: Decodable {
    let dateUtc: String
}

struct ZFVPrice: Decodable {
    let id: String
    let amount: String
    let currency: String
}

struct ZFVDish: Decodable {
    let id: String
    let name: String
    let imageUrl: String?
    let type: String?
    let isVegan: Bool
    let isVegetarian: Bool
    let allergens: [ZFVDishAllergenRelation]
}

struct ZFVDishAllergenRelation: Decodable {
    let allergen: ZFVAllergen
}

struct ZFVAllergen: Decodable {
    let id: String
    let name: String
}
