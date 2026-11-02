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
import os.log
import SwiftUI

/// Responsible for managing navigation within the application.
///
/// Every window has its own instance, so windows navigate, filter and search independently.
class NavigationManager: ObservableObject, @unchecked Sendable {
#if os(watchOS)
    /// The navigation manager of the watch app, which has a single window.
    static let shared = NavigationManager()
#endif

    /// A logger instance for the `NavigationManager` class.
    ///
    /// This logger is initialized with the app's bundle identifier as the subsystem
    /// and the name of the `NavigationManager` class as the category. It is used to
    /// log messages related to the operations and events within the NavigationManager.
    private let logger = Logger(
        subsystem: Bundle.main.safeIdentifier,
        category: String(describing: NavigationManager.self)
    )

    /// A published property that holds the current sheet type to be displayed.
    /// When this property is updated, the view will reactively update to show the corresponding sheet.
    /// - Note: The `SheetType` is an enum that defines the different types of sheets that can be presented.
    @Published var sheet: SheetType?

#if !WIDGET
    /// A published property that holds the currently selected Mensa.
    /// When this property is updated, any views observing it will be notified.
    @Published var selectedMensa: Mensa?

    /// A published property that holds the code for the currently selected weekday.
    /// It is initialized with the corrected weekday code for today.
    @Published var selectedWeekdayCode = Calendar.todayWeedaykETHCorrected

    /// A published property that allows overriding the selected weekday code.
    /// If set, this value will be used instead of `selectedWeekdayCode`.
    @Published var selectedWeekdayCodeOverride: Int?

    /// A published property indicating whether only mensas and meals compatible with the user's allergens
    /// are shown for the selected weekday.
    @Published var allergenFriendlyOnly = false

#if !os(watchOS)
    /// The search term entered by the user in this window.
    /// - Important: This property is not applicable on watchOS.
    @Published var searchTerm = ""
#endif

    /// The weekday the mensa list is shown for: the overriding weekday if one is selected, otherwise today.
    var listWeekdayCode: Int {
        selectedWeekdayCodeOverride ?? Calendar.todayWeedaykETHCorrected
    }

#if !os(watchOS)
    /// The identifier for the Mensa obtained from a universal link.
    /// This property is published to allow SwiftUI views to react to changes.
    ///
    /// - Important: This property is not used in watchOS.
    @Published var universalLinkMensaId: String?

    /// A flag indicating whether an alert for the universal link has been shown.
    /// This property is published to allow SwiftUI views to react to changes.
    ///
    /// - Important: This property is not used in watchOS.
    @Published var universalLinkAlertShown = false

    /// The identifier of a Mensa to select once it is loaded, without an alert if it does not exist anymore,
    /// e.g. when the window is restored or opened for a Mensa.
    /// - Important: This property is not used in watchOS.
    @Published var restoredMensaId: String?

    /// The weekday to show once the Mensa in `restoredMensaId` is selected, instead of today's.
    /// - Important: This property is not used in watchOS.
    var restoredWeekdayCode: Int?

    /// A boolean property that indicates whether the fullscreen meal image is currently shown.
    /// - Important: This property is not available on watchOS.
    @Published var imagePopoverShown = false

    /// The URL of the meal image to be displayed fullscreen.
    /// - Important: This property is not available on watchOS.
    @Published var imagePopoverURL: URL?

    /// The scene of the window, set by `MainWindowView` once a main window is shown,
    /// so it can be brought to the front when an intent or a notification changes it.
    /// - Important: This property is not available on watchOS.
    weak var windowScene: UIWindowScene? {
        didSet {
            windowScene?.session.isMainWindow = true
        }
    }
#endif

#if os(watchOS)
    /// The watch app has no way to turn the allergen filter on or off, so it is always off there.
    private static let isAllergenFilterOnForUsersWithAllergens = false
#else
    /// The allergen filter is on by default for users who have set allergens.
    private static let isAllergenFilterOnForUsersWithAllergens = true
#endif

    /// A set that holds any cancellable subscribers to manage the lifecycle of subscriptions.
    /// This ensures that the subscriptions are cancelled and deallocated properly when no longer needed.
    private var subscribers: Set<AnyCancellable> = []

    init(
        selectedMensa: Mensa? = nil,
        selectedWeekdayCodeOverride: Int? = nil,
        allergenFriendlyOnly: Bool? = nil
    ) {
        self.selectedMensa = selectedMensa
        self.selectedWeekdayCodeOverride = selectedWeekdayCodeOverride
        self.allergenFriendlyOnly = allergenFriendlyOnly ?? (
            Self.isAllergenFilterOnForUsersWithAllergens && !SettingsManager.shared.allergens.isEmpty
        )
#if !os(watchOS)
        initializeLinkHandlers()
#endif
        // Keeps the selected Mensa up to date when the Mensas are reloaded.
        MensaDataManager.shared.$unfilteredMenaList
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] receivedValue in
                guard let self,
                      let selectedMensa = self.selectedMensa,
                      let updatedMensa = receivedValue.first(where: { $0 == selectedMensa }),
                      updatedMensa !== selectedMensa else {
                    return
                }
                self.selectedMensa = updatedMensa
            }.store(in: &subscribers)
        $selectedWeekdayCodeOverride.sink { receivedValue in
            self.selectedWeekdayCode = if let receivedValue {
                receivedValue
            } else {
                Calendar.todayWeedaykETHCorrected
            }
        }.store(in: &subscribers)
        // The allergen filter is turned on when the first allergen is set, and off once none are left.
        SettingsManager.shared.$allergens
            .map { !$0.isEmpty }
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] hasAllergens in
                self?.allergenFriendlyOnly = hasAllergens && Self.isAllergenFilterOnForUsersWithAllergens
            }.store(in: &subscribers)
    }

#if !os(watchOS)
    private func initializeLinkHandlers() {
        $universalLinkMensaId
            .compactMap { $0 }
            // Selects the Mensa once the identifier is set, so it can be cleared again.
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self, let universalLinkMensaId else {
                    return
                }
                select(mensaId: universalLinkMensaId, in: MensaDataManager.shared.unfilteredMenaList, isLink: true)
            }.store(in: &subscribers)
        $restoredMensaId
            .compactMap { $0 }
            // Selects the Mensa once the identifier is set, so it can be cleared again.
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self, let restoredMensaId else {
                    return
                }
                select(mensaId: restoredMensaId, in: MensaDataManager.shared.unfilteredMenaList, isLink: false)
            }.store(in: &subscribers)
        MensaDataManager.shared.$unfilteredMenaList
            .compactMap { $0 }
            .sink { [weak self] receivedValue in
                guard let self else {
                    return
                }
                if let universalLinkMensaId {
                    select(mensaId: universalLinkMensaId, in: receivedValue, isLink: true)
                }
                if let restoredMensaId {
                    select(mensaId: restoredMensaId, in: receivedValue, isLink: false)
                }
            }.store(in: &subscribers)
    }

    /// Selects the Mensa with the given identifier once it is loaded.
    ///
    /// - Parameters:
    ///   - mensaId: The identifier of the Mensa to select.
    ///   - mensaList: The Mensas loaded so far.
    ///   - isLink: Whether the Mensa comes from a link, in which case an alert tells if it does not exist.
    private func select(mensaId: String, in mensaList: [Mensa]?, isLink: Bool) {
        guard let mensaList else {
            return
        }
        guard let mensa = mensaList.first(where: { $0.id == mensaId }) else {
            // The Mensa might come with the Mensas that are still being downloaded
            if MensaDataManager.shared.areAllProvidersUpToDate {
                if isLink {
                    universalLinkAlertShown = true
                    universalLinkMensaId = nil
                } else {
                    restoredMensaId = nil
                    restoredWeekdayCode = nil
                }
            }
            return
        }
        if !isLink {
            restoredMensaId = nil
        }
        selectedMensa = mensa
        if isLink {
            universalLinkMensaId = nil
        }
    }

    /// Clears the search term and removes every filter of the mensa list in this window.
    @MainActor
    func resetFiltersAndSearch() {
        searchTerm = ""
        MensaFilter.removeAll(in: self)
    }
#else
    /// Removes every filter of the mensa list.
    @MainActor
    func resetFiltersAndSearch() {
        MensaFilter.removeAll(in: self)
    }
#endif
#endif
}

#if !WIDGET
extension NavigationManager {
    /// An example instance of `NavigationManager` for testing or preview purposes.
    /// This instance is initialized with a selected mensa set to the example mensa.
    static let example = NavigationManager(
        selectedMensa: .example
    )
}
#endif

extension NavigationManager {
    /// The navigation manager of the main window that was active last.
    /// Links, intents and notifications open there, so they only ever change one window.
    @MainActor private static weak var primaryWindow: NavigationManager?

    /// The actions waiting for a main window, e.g. those of an intent that launched the app.
    @MainActor private static var pendingPrimaryWindowActions: [@MainActor (NavigationManager) -> Void] = []

#if !WIDGET && !os(watchOS)
    /// Brings this main window to the front, e.g. after an intent changed it while another window was in front.
    @MainActor
    private func bringWindowToFront() {
        guard let windowScene,
              windowScene.activationState != .foregroundActive else {
            return
        }
        if #available(iOS 17.0, visionOS 1.0, *) {
            UIApplication.shared.activateSceneSession(for: .init(session: windowScene.session))
        } else {
            UIApplication.shared.requestSceneSessionActivation(windowScene.session, userActivity: nil, options: nil)
        }
    }
#endif

    /// Makes this window's navigation manager the one links, intents and notifications open in,
    /// and runs the actions that were waiting for a main window.
    @MainActor
    func becomePrimaryWindow() {
        Self.primaryWindow = self
        let actions = Self.pendingPrimaryWindowActions
        Self.pendingPrimaryWindowActions = []
        for action in actions {
            action(self)
        }
    }

    /// Runs the given action in the main window that was active last.
    ///
    /// If no main window is open yet, the action runs once one is, and one is opened if only Mensa windows are.
    @MainActor
    static func inPrimaryWindow(_ action: @escaping @MainActor (NavigationManager) -> Void) {
        if let primaryWindow {
            action(primaryWindow)
#if !WIDGET && !os(watchOS)
            primaryWindow.bringWindowToFront()
#endif
            return
        }
        pendingPrimaryWindowActions.append(action)
#if !WIDGET && !os(watchOS)
        // While the app launches its first window registers itself. Otherwise only Mensa windows are shown:
        // a main window in the background, which is not connected after a relaunch, is brought to the front,
        // or a new one is opened.
        guard UIApplication.shared.supportsMultipleScenes,
              UIApplication.shared.connectedScenes.contains(where: { $0.activationState == .foregroundActive }) else {
            return
        }
        let mainWindowSession = UIApplication.shared.openSessions.first { $0.isMainWindow }
        if #available(iOS 17.0, visionOS 1.0, *) {
            UIApplication.shared.activateSceneSession(for: mainWindowSession.map { .init(session: $0) } ?? .init())
        } else {
            UIApplication.shared.requestSceneSessionActivation(mainWindowSession, userActivity: nil, options: nil)
        }
#endif
    }
}

#if !WIDGET && !os(watchOS)
extension UISceneSession {
    /// The `userInfo` key marking the session of a main window.
    private static let isMainWindowKey = "isMainWindow"

    /// Whether the session belongs to a main window, as opposed to a Mensa window.
    /// It is stored in the session's `userInfo`, so it is known after a relaunch, before the window is connected.
    var isMainWindow: Bool {
        get { userInfo?[Self.isMainWindowKey] as? Bool ?? false }
        set { userInfo = (userInfo ?? [:]).merging([Self.isMainWindowKey: newValue]) { $1 } }
    }
}
#endif
