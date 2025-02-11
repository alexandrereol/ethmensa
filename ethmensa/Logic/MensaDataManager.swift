//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import os.log
import Foundation
import Combine

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
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: MensaDataManager.self)
    )

    /// A published property that holds an optional array of `Mensa` objects.
    /// This array represents the unfiltered list of Mensa data.
    @Published var unfilteredMenaList: [Mensa]?

    /// A published property that holds a list of `Mensa` objects.
    /// This list may contain filtered values based on certain criteria.
    @Published var mensaList: [Mensa]?

#if !os(watchOS)
    /// A published property that holds the search term entered by the user.
    /// - Important: This property is not applicable on watchOS.
    @Published var searchTerm = ""
#endif

    /// A set that holds any cancellable subscribers to manage the lifecycle of subscriptions.
    /// This ensures that the subscriptions are cancelled and deallocated properly when no longer needed.
    private var subscribers = Set<AnyCancellable>()

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
        SettingsManager.shared.$sortBy.sink { _ in
            Task {
                await self.updateFiltersOnMensaList()
            }
        }.store(in: &subscribers)
        SettingsManager.shared.$mensaShowType.sink { _ in
            Task {
                await self.updateFiltersOnMensaList()
            }
        }.store(in: &subscribers)
        SettingsManager.shared.$mensaLocationType.sink { _ in
            Task {
                await self.updateFiltersOnMensaList()
            }
        }.store(in: &subscribers)
#if !os(watchOS)
        $searchTerm.sink { _ in
            Task {
                await self.updateFiltersOnMensaList()
            }
        }.store(in: &subscribers)
#endif
        Task {
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
    /// - Reloads the unfiltered mensa list asynchronously.
    func resetFiltersAndSearch() async {
        await MainActor.run {
#if !os(watchOS)
            searchTerm = ""
#endif
            SettingsManager.shared.sortBy = .def
            SettingsManager.shared.mensaShowType = .all
            SettingsManager.shared.mensaLocationType = .all
            NavigationManager.shared.selectedWeekdayCodeOverride = nil
        }
    }

    /// Reloads the unfiltered list of Mensa asynchronously.
    ///
    /// This function fetches the latest Mensa data from the API and updates the unfiltered Mensa list.
    /// It also updates the selected Mensa in the `NavigationManager` if it exists in the new list.
    /// Additionally, it retrieves coordinates for each Mensa and updates the filters on the Mensa list.
    ///
    /// - Note: This function should be called from an asynchronous context.
    func reloadUnfilteredMensaList() async {
        let newUnfilteredMenaList = await API.shared.get()
        await MainActor.run {
            self.unfilteredMenaList = newUnfilteredMenaList
        }
        if let selectedMensa = NavigationManager.shared.selectedMensa,
           let updatedMensa = newUnfilteredMenaList.first(where: { $0 == selectedMensa }) {
            await MainActor.run {
                NavigationManager.shared.selectedMensa = updatedMensa
            }
        }
        for mensa in newUnfilteredMenaList {
            _ = await mensa.getCoordinates()
        }
        await updateFiltersOnMensaList()
    }

    /// Updates the filters on the mensa list asynchronously.
    /// 
    /// This function performs the following steps:
    /// 1. Checks if `unfilteredMenaList` is available. If not, sets `mensaList` to `nil` on the main actor and returns.
    /// 2. Copies `unfilteredMenaList` to a local variable `mensaList`.
    /// 3. On watchOS, removes mensas without a menu for today. On other platforms, removes mensas without a menu for
    ///    today if the setting is enabled and performs a search on the mensa list.
    /// 4. Applies additional filters to the mensa list asynchronously.
    /// 5. Sorts the mensa list.
    /// 6. Sets the final filtered and sorted mensa list to `self.mensaList` on the main actor.
    private func updateFiltersOnMensaList() async {
        guard let unfilteredMenaList else {
            await MainActor.run {
                self.mensaList = nil
            }
            return
        }
        var mensaList = unfilteredMenaList
#if os(watchOS)
        removeMensasWithoutMenuToday(mensaList: &mensaList)
#else
        if SettingsManager.shared.hideMensaWithNoMenus {
            removeMensasWithoutMenuToday(mensaList: &mensaList)
        }
        search(mensaList: &mensaList)
#endif
        await filter(mensaList: &mensaList)
        sort(mensaList: &mensaList)
        let finalMensaList = mensaList
        await MainActor.run {
            self.mensaList = finalMensaList
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
    /// - If a weekday code override is selected in `NavigationManager`, only include Mensa objects that do not have
    ///   meals with allergens specified in `SettingsManager`.
    /// - If the mensa show type in `SettingsManager` is set to `.open`, only include Mensa objects that are currently
    ///   open.
    /// - If the mensa location type in `SettingsManager` is not set to `.all`, only include Mensa objects that match
    ///   the selected location type.
    /// - If the `hideMensaWithNoMenus` setting in `SettingsManager` is enabled, remove Mensa objects that have
    ///   no meal times.
    private func filter(mensaList: inout [Mensa]) async {
        var filteredArray: [Mensa] = []
        for mensa in mensaList {
            let allergenCond = if let weekdayCodeOverride = NavigationManager.shared.selectedWeekdayCodeOverride {
                !mensa.mealTimes.filter { mealTime in
                    mealTime.weekdayCode == weekdayCodeOverride
                }.allSatisfy { mealTime in
                    mealTime.meals.allSatisfy { meal in
                        !Set(SettingsManager.shared.allergens).isDisjoint(with: meal.allergen ?? [])
                    }
                }
            } else {
                true
            }
            let openCond = if SettingsManager.shared.mensaShowType == .open {
                mensa.getOpeningTimes() == .open
            } else {
                true
            }
            let locationCond = if SettingsManager.shared.mensaLocationType == .all {
                true
            } else {
                SettingsManager.shared.mensaLocationType == (await mensa.getLocationType())
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
                mensa1.getClicks() > mensa2.getClicks()
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
