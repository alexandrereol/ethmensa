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

    /// Only mensas serving at least one meal without the user's allergens on the selected day.
    case allergenFriendly

    /// The given sorting instead of the default one.
    case sorting(SortType)

    var id: Self { self }

    /// The currently active filters, in the order they are displayed.
    static var active: [Self] {
        let settingsManager = SettingsManager.shared
        let navigationManager = NavigationManager.shared
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
        if navigationManager.allergenFriendlyOnly {
            filters.append(.allergenFriendly)
        }
        if settingsManager.sortBy != .def {
            filters.append(.sorting(settingsManager.sortBy))
        }
        return filters
    }

    /// Whether any filter is active.
    static var isAnyActive: Bool {
        !active.isEmpty
    }

    /// Removes every filter from the mensa list.
    static func removeAll() {
        SettingsManager.shared.mensaShowType = .all
        SettingsManager.shared.mensaLocationType = .all
        NavigationManager.shared.selectedWeekdayCodeOverride = nil
        NavigationManager.shared.allergenFriendlyOnly = false
        SettingsManager.shared.sortBy = .def
    }

    /// Applies this filter to the mensa list.
    func apply() {
        switch self {
        case .openOnly:
            SettingsManager.shared.mensaShowType = .open
        case .campus(let campusType):
            SettingsManager.shared.mensaLocationType = campusType
        case .weekday(let weekdayCode):
            NavigationManager.shared.selectedWeekdayCodeOverride = weekdayCode
        case .allergenFriendly:
            NavigationManager.shared.allergenFriendlyOnly = true
        case .sorting(let sortType):
            SettingsManager.shared.sortBy = sortType
        }
    }

    /// Removes this filter from the mensa list.
    func remove() {
        switch self {
        case .openOnly:
            SettingsManager.shared.mensaShowType = .all
        case .campus:
            SettingsManager.shared.mensaLocationType = .all
        case .weekday:
            NavigationManager.shared.selectedWeekdayCodeOverride = nil
        case .allergenFriendly:
            NavigationManager.shared.allergenFriendlyOnly = false
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
        case .allergenFriendly: "checkmark.shield"
        case .sorting: "arrow.up.arrow.down"
        }
    }
}
