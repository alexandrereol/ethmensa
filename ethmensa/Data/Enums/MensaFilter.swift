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

/// A filter, or a non-default sorting, that is applied to the mensa list.
///
/// This is the single place that knows how the filters are stored: when a filter is active,
/// and how it is applied and removed again.
enum MensaFilter: Hashable, Identifiable {
    /// Only mensas that are currently open.
    case openOnly

    /// Only mensas on the given campus.
    case campus(Campus.CampusType)

    /// The menus of the given weekday instead of today's.
    case weekday(Int)

    /// Only mensas serving at least one meal of the given diet on the selected day.
    case diet(Diet)

    /// Only mensas serving at least one meal without the user's allergens on the selected day.
    case allergenFriendly

    /// The given sorting instead of the default one.
    case sorting(SortType)

    var id: Self { self }

    /// A diet the meals can be filtered by, based on the labels the mensas give their meals.
    /// - Important: The diet is only kept for the session of a window. It is never saved, synced or logged.
    enum Diet: CaseIterable, Hashable {
        /// Every meal, labelled or not.
        case all

        /// Vegetarian meals, including vegan ones.
        case vegetarian

        /// Vegan meals.
        case vegan

        /// Whether the given meal is of this diet.
        /// Meals the mensa did not label never match a diet other than `.all`.
        func includes(_ meal: Meal) -> Bool {
            let mealTypes = meal.mealType ?? []
            return switch self {
            case .all:
                true
            case .vegetarian:
                // `Meal` drops the vegetarian label of vegan meals.
                mealTypes.contains(.vegetarian) || mealTypes.contains(.vegan)
            case .vegan:
                mealTypes.contains(.vegan)
            }
        }

        /// The localized name of the diet.
        var localizedString: String {
            switch self {
            case .all: .init(localized: "ALL_MEALS")
            case .vegetarian: .init(localized: "VEGETARIAN")
            case .vegan: .init(localized: "VEGAN")
            }
        }

        /// The name of the SF Symbol representing the diet, matching the labels of the meals.
        var systemImageName: String {
            switch self {
            case .all: "fork.knife"
            case .vegetarian: "leaf"
            case .vegan: "leaf.fill"
            }
        }
    }

    /// The filters active in a window, in the order they are displayed.
    /// - Parameter navigationManager: The navigation manager of the window, which holds its own filters.
    static func active(in navigationManager: NavigationManager) -> [Self] {
        let settingsManager = SettingsManager.shared
        var filters: [Self] = []
        // Whether a mensa is open refers to now, so it cannot filter the list of another day.
        if settingsManager.mensaShowType != .all, navigationManager.selectedWeekdayCodeOverride == nil {
            filters.append(.openOnly)
        }
        if settingsManager.mensaLocationType != .all {
            filters.append(.campus(settingsManager.mensaLocationType))
        }
        if let weekdayCode = navigationManager.selectedWeekdayCodeOverride {
            filters.append(.weekday(weekdayCode))
        }
        if navigationManager.diet != .all {
            filters.append(.diet(navigationManager.diet))
        }
        if navigationManager.allergenFriendlyOnly {
            filters.append(.allergenFriendly)
        }
        if settingsManager.sortBy != .def {
            filters.append(.sorting(settingsManager.sortBy))
        }
        return filters
    }

    /// Whether any filter is active in a window.
    static func isAnyActive(in navigationManager: NavigationManager) -> Bool {
        !active(in: navigationManager).isEmpty
    }

    /// Removes every filter from the mensa list of a window.
    static func removeAll(in navigationManager: NavigationManager) {
        SettingsManager.shared.mensaShowType = .all
        SettingsManager.shared.mensaLocationType = .all
        navigationManager.selectedWeekdayCodeOverride = nil
        navigationManager.diet = .all
        navigationManager.allergenFriendlyOnly = false
        SettingsManager.shared.sortBy = .def
    }

    /// Applies this filter to the mensa list of a window.
    func apply(in navigationManager: NavigationManager) {
        switch self {
        case .openOnly:
            SettingsManager.shared.mensaShowType = .open
        case .campus(let campusType):
            SettingsManager.shared.mensaLocationType = campusType
        case .weekday(let weekdayCode):
            navigationManager.selectedWeekdayCodeOverride = weekdayCode
        case .diet(let diet):
            navigationManager.diet = diet
        case .allergenFriendly:
            navigationManager.allergenFriendlyOnly = true
        case .sorting(let sortType):
            SettingsManager.shared.sortBy = sortType
        }
    }

    /// Removes this filter from the mensa list of a window.
    func remove(in navigationManager: NavigationManager) {
        switch self {
        case .openOnly:
            SettingsManager.shared.mensaShowType = .all
        case .campus:
            SettingsManager.shared.mensaLocationType = .all
        case .weekday:
            navigationManager.selectedWeekdayCodeOverride = nil
        case .diet:
            navigationManager.diet = .all
        case .allergenFriendly:
            navigationManager.allergenFriendlyOnly = false
        case .sorting:
            SettingsManager.shared.sortBy = .def
        }
    }

    /// The localized string for the filter.
    var localizedString: String {
        switch self {
        case .openOnly:
            .init(localized: "OPEN_ONLY")
        case .campus(let campusType):
            campusType.localizedString
        case .weekday(let weekdayCode):
            Date.weekdaysStartingAtOne.first { $0.index == weekdayCode }?.string ?? .init(localized: "WEEKDAY")
        case .diet(let diet):
            diet.localizedString
        case .allergenFriendly:
            .init(localized: "ALLERGEN_FRIENDLY")
        case .sorting(let sortType):
            sortType.localizedString
        }
    }

    /// The name of the SF Symbol representing the filter.
    var systemImageName: String {
        switch self {
        case .openOnly: "clock"
        case .campus: "mappin"
        case .weekday: "calendar"
        case .diet(let diet): diet.systemImageName
        case .allergenFriendly: "checkmark.shield"
        case .sorting: "arrow.up.arrow.down"
        }
    }
}

extension NavigationManager {
    /// The meals of a meal time shown in this window: those of the selected diet, and without the user's
    /// allergens while the allergen-friendly filter is active.
    func shownMeals(of mealTime: MealTime) -> [Meal] {
        let meals = allergenFriendlyOnly ? mealTime.allergenCompatibleMeals : mealTime.meals
        return diet == .all ? meals : meals.filter(diet.includes)
    }
}
