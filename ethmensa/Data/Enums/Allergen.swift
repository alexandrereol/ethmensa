//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Foundation

/// An enumeration representing various allergens.
enum Allergen: Identifiable, Hashable {
    /// Represents the presence of gluten as an allergen.
    case gluten

    /// Represents the presence of crustaceans as an allergen.
    case crustaceans

    /// Represents the presence of eggs as an allergen.
    case eggs

    /// Represents the presence of fish as an allergen.
    case fish

    /// Represents the presence of peanuts as an allergen.
    case peanuts

    /// Represents the presence of soya as an allergen.
    case soya

    /// Represents the presence of lactose as an allergen.
    case lactose

    /// Represents the presence of nuts as an allergen.
    case nuts

    /// Represents the presence of celery as an allergen.
    case celery

    /// Represents the presence of mustard as an allergen.
    case mustard

    /// Represents the presence of sesame as an allergen.
    case sesame

    /// Represents the presence of sulphur dioxide as an allergen.
    case sulphurdioxide

    /// Represents the presence of lupin as an allergen.
    case lupin

    /// Represents the presence of molluscs as an allergen.
    case molluscs

    /// Represents the presence of wheat as an allergen.
    case wheat

    /// Represents an allergen that is not part of the predefined list.
    /// In case the API provided allergen is not recognized, user other("RAW_STRING").
    case other(String)

    /// A computed property that returns the id of the allergen.
    var id: String {
        self.localizedString
    }

    init(rawValue: String) {
        self = Allergen.allCases.first { currentAllergen in
            currentAllergen.rawValue == rawValue
        } ?? .other(rawValue)
    }

    /// A computed property that returns the raw string value of the allergen.
    var rawValue: String {
        switch self {
        case .gluten: "gluten"
        case .soya: "soya"
        case .crustaceans: "crustaceans"
        case .eggs: "eggs"
        case .fish: "fish"
        case .peanuts: "peanuts"
        case .lactose: "lactose"
        case .nuts: "nuts"
        case .celery: "celery"
        case .mustard: "mustard"
        case .sesame: "sesame"
        case .sulphurdioxide: "sulphurdioxide"
        case .lupin: "lupin"
        case .molluscs: "molluscs"
        case .wheat: "wheat"
        case .other(let value): value
        }
    }

    /// A computed property that returns the localized string representation of the allergen.
    var localizedString: String {
        switch self {
        case .gluten: .init(localized: "GLUTEN")
        case .soya: .init(localized: "SOYA")
        case .crustaceans: .init(localized: "CRUSTACEANS")
        case .eggs: .init(localized: "EGGS")
        case .fish: .init(localized: "FISH")
        case .peanuts: .init(localized: "PEANUTS")
        case .lactose: .init(localized: "LACTOSE")
        case .nuts: .init(localized: "NUTS")
        case .celery: .init(localized: "CELERY")
        case .mustard: .init(localized: "MUSTARD")
        case .sesame: .init(localized: "SESAME")
        case .sulphurdioxide: .init(localized: "SULPHURDIOXIDE")
        case .lupin: .init(localized: "LUPIN")
        case .molluscs: .init(localized: "MOLLUSCS")
        case .wheat: .init(localized: "WHEAT")
        case .other(let string): string
        }
    }
}

extension Allergen: CaseIterable {
    static var allCases: [Self] {
        [
            .gluten,
            .crustaceans,
            .eggs,
            .fish,
            .peanuts,
            .soya,
            .lactose,
            .nuts,
            .celery,
            .mustard,
            .sesame,
            .sulphurdioxide,
            .lupin,
            .molluscs,
            .wheat
        ]
    }
}

extension Allergen {
    // swiftlint:disable:next orphaned_doc_comment
    /// Get the Allergen from the ETH-API provided string.
    // swiftlint:disable:next cyclomatic_complexity
    static func fromETHString(_ string: String) -> Self? {
        switch string.lowercased() {
        case "gluten wheat": .gluten
        case "crustaceans", "krebstiere": .crustaceans
        case "eggs": .eggs
        case "fish": .fish
        case "peanuts": .peanuts
        case "soya": .soya
        case "lactose", "milk": .lactose
        case "nuts": .nuts
        case "celery": .celery
        case "mustard": .mustard
        case "sesame": .sesame
        case "sulfites": .sulphurdioxide
        case "lupin": .lupin
        case "molluscs": .molluscs
        default: .other(string)
        }
    }

    // swiftlint:disable:next orphaned_doc_comment
    /// Get the Allergen from the UZH-API provided string.
    // swiftlint:disable:next cyclomatic_complexity
    static func fromUZHString(_ string: String) -> Self? {
        return switch string.uppercased() {
        case "FREI_VON_DEKLARAT_PFLICHTIGEN_ALLERGENEN": nil
        case "GLUTEN": .gluten
        case "SOJA": .soya
        case "EI": .eggs
        case "FISCH": .fish
        case "ERDNUSS": .peanuts
        case "KREBSTIERE": .crustaceans
        case "MILCH_LAKTOSE": .lactose
        case "SCHALENFRUECHTE", "CASHEW", "MANDEL": .nuts
        case "SELLERIE": .celery
        case "SENF": .mustard
        case "SESAM": .sesame
        case "SULPHURDIOXIDE", "SCHWFELDIOXID_SULFITE": .sulphurdioxide
        case "WEIZEN": .wheat
        default: .other(string)
        }
    }
}

extension Array<Allergen> {
    /// A computed property that returns a localized string representation of the allergen.
    var localizedString: String {
        if self.isEmpty {
            .init(localized: "NO_ALLERGENS_SELECTED")
        } else {
            .init(localized: "\(self.count)_ALLERGENS_SELECTED")
        }
    }
}
