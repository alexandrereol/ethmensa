//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Combine
import os.log
import SwiftUI

/// Responsible for managing navigation within the application.
class NavigationManager: ObservableObject, @unchecked Sendable {
    /// A singleton instance of `NavigationManager` to manage mensa data.
    ///
    /// Use `NavigationManager.shared` to access the shared instance.
    static let shared = NavigationManager()

    /// A logger instance for the `NavigationManager` class.
    ///
    /// This logger is initialized with the app's bundle identifier as the subsystem
    /// and the name of the `NavigationManager` class as the category. It is used to
    /// log messages related to the operations and events within the NavigationManager.
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: NavigationManager.self)
    )

    /// A published property that holds the currently selected Mensa.
    /// When this property is updated, any views observing it will be notified.
    @Published var selectedMensa: Mensa?

    /// A published property that holds the code for the currently selected weekday.
    /// It is initialized with the corrected weekday code for today.
    @Published var selectedWeekdayCode = Calendar.todayWeedaykETHCorrected

    /// A published property that allows overriding the selected weekday code.
    /// If set, this value will be used instead of `selectedWeekdayCode`.
    @Published var selectedWeekdayCodeOverride: Int?

    /// A published property that holds the current sheet type to be displayed.
    /// When this property is updated, the view will reactively update to show the corresponding sheet.
    /// - Note: The `SheetType` is an enum that defines the different types of sheets that can be presented.
    @Published var sheet: SheetType?

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

    /// A boolean property that indicates whether the meal image popover is currently shown.
    /// - Important: This property is not available on watchOS.
    @Published var imagePopoverShown = false

    /// A string property that holds the URL of the meal image to be displayed in the popover.
    /// - Important: This property is not available on watchOS.
    @Published var imagePopoverURLString = ""
#endif

    /// A set that holds any cancellable subscribers to manage the lifecycle of subscriptions.
    /// This ensures that the subscriptions are cancelled and deallocated properly when no longer needed.
    private var subscribers: Set<AnyCancellable> = []

    init(
        selectedMensa: Mensa? = nil
    ) {
        self.selectedMensa = selectedMensa
#if !os(watchOS)
        initializeLinkHandlers()
#endif
        $selectedWeekdayCodeOverride.sink { receivedValue in
            self.selectedWeekdayCode = if let receivedValue {
                receivedValue
            } else {
                Calendar.todayWeedaykETHCorrected
            }
        }.store(in: &subscribers)
    }

#if !os(watchOS)
    private func initializeLinkHandlers() {
        $universalLinkMensaId
            .compactMap { $0 }
            .sink { receivedValue in
            guard let unfilteredMenaList = MensaDataManager.shared.unfilteredMenaList else {
                return
            }
            guard let mensa = unfilteredMenaList.first(where: { $0.id == receivedValue }) else {
                self.universalLinkAlertShown = true
                return
            }
            self.selectedMensa = mensa
            self.universalLinkMensaId = nil
        }.store(in: &subscribers)
        MensaDataManager.shared.$unfilteredMenaList
            .compactMap { $0 }
            .sink { receivedValue in
            guard let universalLinkMensaId = self.universalLinkMensaId else {
                return
            }
            guard let mensa = receivedValue.first(where: { $0.id == universalLinkMensaId }) else {
                self.universalLinkAlertShown = true
                return
            }
            self.selectedMensa = mensa
            self.universalLinkMensaId = nil
        }.store(in: &subscribers)
    }
#endif
}

extension NavigationManager {
    /// An example instance of `NavigationManager` for testing or preview purposes.
    /// This instance is initialized with a selected mensa set to the example mensa.
    static let example = NavigationManager(
        selectedMensa: .example
    )
}
