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

import Combine
import Foundation
import os.log

/// Responsible for managing the data related to Mensas.
class MensaDataManager: ObservableObject, @unchecked Sendable {
    /// A singleton instance of `MensaDataManager` to manage mensa data.
    /// 
    /// Use `MensaDataManager.shared` to access the shared instance.
    static let shared = MensaDataManager()

    /// A logger instance for the `MensaDataManager` class.
    ///
    /// This logger is initialized with the app's bundle identifier as the subsystem
    /// and the name of the `MensaDataManager` class as the category. It is used to
    /// log messages related to the operations and events within the MensaDataManager.
    private let logger = Logger(
        subsystem: Bundle.main.safeIdentifier,
        category: String(describing: MensaDataManager.self)
    )

    /// A published property that holds an optional array of `Mensa` objects.
    /// This array represents the unfiltered list of Mensa data.
    @Published var unfilteredMenaList: [Mensa]?

    /// The mensa list with the search term, filters and sorting applied, or `nil` while it is loading.
    ///
    /// The list is derived on every access, so it always reflects the current settings. Views observing
    /// `SettingsManager` and `NavigationManager` re-render, and animate, as soon as a filter changes.
    var mensaList: [Mensa]? {
        // Filtering by campus needs the campus of every mensa, so the list keeps loading until they are known.
        guard var mensaList = unfilteredMenaList,
              areLocationTypesResolved || SettingsManager.shared.mensaLocationType == .all else {
            return nil
        }
#if os(watchOS)
        removeMensasWithoutMenuToday(mensaList: &mensaList)
#else
        if SettingsManager.shared.hideMensaWithNoMenus {
            removeMensasWithoutMenuToday(mensaList: &mensaList)
        }
        search(mensaList: &mensaList)
#endif
        filter(mensaList: &mensaList)
        sort(mensaList: &mensaList)
        return mensaList
    }

#if !os(watchOS)
    /// A published property that holds the search term entered by the user.
    /// - Important: This property is not applicable on watchOS.
    @Published var searchTerm = ""
#endif

    /// Whether the campus of every mensa in `unfilteredMenaList` has been determined.
    @Published private var areLocationTypesResolved = false

    /// The click counts of the mensas, read when the list is loaded.
    /// Sorting uses this snapshot so the list does not reorder while the user taps through it.
    private var clickCounts: [String: Int] = [:]

    /// Tracks the current in-flight reload task.
    /// New tasks cancel the previous one to prevent concurrent data races on `@Published` properties.
    private var currentUpdateTask: Task<Void, Never>?

    /// A computed property that determines if the mensa data is filtered based on user settings.
    ///
    /// The data is considered filtered if any of the following conditions are met:
    /// - The sorting preference is not the default.
    /// - The mensa show type is not set to show all.
    /// - The mensa location type is not set to show all.
    var isFiltered: Bool {
        SettingsManager.shared.sortBy != .def
        || SettingsManager.shared.mensaShowType != .all
        || SettingsManager.shared.mensaLocationType != .all
    }

    init() {
        currentUpdateTask = Task {
            await reloadUnfilteredMensaList()
        }
    }

    /// Resets the filters and search term to their default values and reloads the unfiltered mensa list.
    /// 
    /// This function performs the following actions:
    /// - Resets the search term to an empty string (except on watchOS).
    /// - Sets the sorting preference to the default value.
    /// - Sets the mensa show type to show all.
    /// - Sets the mensa location type to show all.
    /// - Clears any selected weekday code override in the navigation manager.
    /// - Turns off the allergen-friendly filter.
    /// - Reloads the unfiltered mensa list asynchronously.
    func resetFiltersAndSearch() async {
        await MainActor.run {
#if !os(watchOS)
            searchTerm = ""
#endif
            MensaFilter.removeAll()
        }
    }

    /// Reloads the unfiltered list of Mensa asynchronously.
    ///
    /// This function fetches the latest Mensa data from the API and updates the unfiltered Mensa list.
    /// It also updates the selected Mensa in the `NavigationManager` if it exists in the new list.
    /// Afterwards, it determines the campus of every Mensa, which filtering by campus relies on.
    ///
    /// - Note: This function should be called from an asynchronous context.
    func reloadUnfilteredMensaList() async {
        currentUpdateTask?.cancel()
        let task = Task {
            let newUnfilteredMenaList = await API.shared.get()
            let newClickCounts = Dictionary(
                newUnfilteredMenaList.map { ($0.id, $0.getClicks()) },
                uniquingKeysWith: max
            )
            guard !Task.isCancelled else { return }
            await MainActor.run {
                // A mensa keeps its campus, so only mensas that were not loaded before have to be resolved.
                let previousLocationTypes = Dictionary(
                    (self.unfilteredMenaList ?? []).map { ($0.id, $0.getLocationTypeCache) },
                    uniquingKeysWith: { first, _ in first }
                )
                for mensa in newUnfilteredMenaList {
                    mensa.getLocationTypeCache = previousLocationTypes[mensa.id] ?? nil
                }
                self.areLocationTypesResolved = self.areLocationTypesResolved && newUnfilteredMenaList.allSatisfy {
                    previousLocationTypes.keys.contains($0.id)
                }
                self.clickCounts = newClickCounts
                self.unfilteredMenaList = newUnfilteredMenaList
            }
            guard !Task.isCancelled else { return }
            if let selectedMensa = NavigationManager.shared.selectedMensa,
               let updatedMensa = newUnfilteredMenaList.first(where: { $0 == selectedMensa }) {
                await MainActor.run {
                    NavigationManager.shared.selectedMensa = updatedMensa
                }
            }
            guard !Task.isCancelled else { return }
            for mensa in newUnfilteredMenaList {
                guard !Task.isCancelled else { return }
                _ = await mensa.getLocationType()
            }
            guard !Task.isCancelled else { return }
            await MainActor.run {
                if self.unfilteredMenaList?.elementsEqual(newUnfilteredMenaList, by: ===) == true {
                    self.areLocationTypesResolved = true
                }
            }
        }
        currentUpdateTask = task
        await task.value
    }

    /// Forgets the click counts the smart sorting is based on, e.g. after they have been reset.
    func resetClickCounts() {
        objectWillChange.send()
        clickCounts = [:]
    }

    /// Forgets the campuses of the mensas and determines them again, e.g. after the geocoding cache has been reset.
    func resetLocationTypes() {
        unfilteredMenaList?.forEach { $0.getLocationTypeCache = nil }
        areLocationTypesResolved = false
        Task {
            await reloadUnfilteredMensaList()
        }
    }

#if !os(watchOS)
    /// Filters the given list of Mensa objects based on the search term.
    /// - Parameter mensaList: The list of Mensa objects to be filtered. This parameter is modified in place.
    /// - Note: If the search term is empty, the list remains unchanged.
    /// - Important: This function is not applicable on watchOS.
    private func search(mensaList: inout [Mensa]) {
        guard !searchTerm.isEmpty else {
            return
        }
        mensaList.removeAll { mensa in
            !mensa.name.localizedStandardContains(searchTerm)
        }
    }
#endif

    /// Filters the given list of Mensa objects based on various conditions.
    /// - Parameter mensaList: The list of Mensa objects to be filtered. This parameter is modified in place.
    /// 
    /// The filtering conditions are:
    /// - If the allergen-friendly filter is active, only include Mensa objects that do not have meals with allergens
    ///   specified in `SettingsManager` on the weekday of the list.
    /// - If the open-only filter is active, only include Mensa objects that are currently open.
    /// - If the mensa location type in `SettingsManager` is not set to `.all`, only include Mensa objects that match
    ///   the selected location type.
    /// - If the `hideMensaWithNoMenus` setting in `SettingsManager` is enabled, remove Mensa objects that have
    ///   no meal times.
    private func filter(mensaList: inout [Mensa]) {
        let activeFilters = MensaFilter.active
        var filteredArray: [Mensa] = []
        for mensa in mensaList {
            let allergenCond = if activeFilters.contains(.allergenFriendly) {
                !mensa.mealTimes.filter { mealTime in
                    mealTime.weekdayCode == NavigationManager.shared.listWeekdayCode
                }.allSatisfy { mealTime in
                    mealTime.meals.allSatisfy { meal in
                        !Set(SettingsManager.shared.allergens).isDisjoint(with: meal.allergen ?? [])
                    }
                }
            } else {
                true
            }
            let openCond = if activeFilters.contains(.openOnly) {
                mensa.getOpeningTimes() == .open
            } else {
                true
            }
            let locationCond = if SettingsManager.shared.mensaLocationType == .all {
                true
            } else {
                // The campus of every Mensa is determined in `reloadUnfilteredMensaList()`.
                SettingsManager.shared.mensaLocationType == mensa.getLocationTypeCache
            }
            if allergenCond,
               openCond,
               locationCond {
                filteredArray.append(mensa)
            }
        }
        if SettingsManager.shared.hideMensaWithNoMenus {
            filteredArray.removeAll { mensa in
                mensa.mealTimes.isEmpty
            }
        }
        mensaList = filteredArray
    }

    /// Sorts the given list of Mensa objects based on the current sorting setting.
    /// - Parameter mensaList: The list of Mensa objects to be sorted. This parameter is modified in place.
    /// - Note: The sorting criteria are determined by the `SettingsManager.shared.sortBy` value.
    ///   - If the sorting criteria is `.def`, the list is sorted by the number of clicks in descending order.
    ///   - If the sorting criteria is `.name`, the list is sorted by the name in ascending order.
    /// - Important: When not running on App Clip or watchOS, the `SharedWithYouManager.shared.sharedWithYouHandler`
    ///   is called to handle additional sorting or modifications to the list.
    private func sort(mensaList: inout [Mensa]) {
        switch SettingsManager.shared.sortBy {
        case .def:
            mensaList.sort { (mensa1, mensa2) in
                clickCounts[mensa1.id, default: -1] > clickCounts[mensa2.id, default: -1]
            }
#if !APPCLIP && !os(watchOS)
            SharedWithYouManager.shared.sharedWithYouHandler(&mensaList)
#endif
        case .name:
            mensaList.sort { (mensa1, mensa2) in
                mensa1.name.capitalized < mensa2.name.capitalized
            }
        }
    }

    /// Removes mensas from the provided list that do not have a menu for today.
    /// - Parameter mensaList: The list of mensas to be filtered. This parameter is modified in place.
    private func removeMensasWithoutMenuToday(mensaList: inout [Mensa]) {
        mensaList.removeAll { mensa in
            if let todayMealTime = mensa.mealTimes.filter({ mealTime in
                mealTime.weekdayCode == NavigationManager.shared.selectedWeekdayCode
            }).first {
                todayMealTime.meals.isEmpty
            } else {
                true
            }
        }
    }
}
