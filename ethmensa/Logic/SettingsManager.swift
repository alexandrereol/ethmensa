//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Combine
import Foundation

#if !APPCLIP && !os(watchOS)
import UserNotifications
#endif

#if !APPCLIP && !os(watchOS) && !os(visionOS)
import CoreLocation
#endif

// swiftlint:disable:next orphaned_doc_comment
/// Responsible for managing the settings of the application.
// swiftlint:disable:next type_body_length
class SettingsManager: ObservableObject, @unchecked Sendable {
    /// A singleton instance of `SettingsManager` to manage mensa data.
    ///
    /// Use `SettingsManager.shared` to access the shared instance.
    static let shared = SettingsManager()

    /// A shared instance of `UserDefaults` configured with the specified app group suite name.
    /// This instance is used to store and retrieve user settings across different parts of the app.
    /// - Note: This instance is also used outside this class.
    let udf = UserDefaults(suiteName: .userDefaultsGroup)!

    /// A reference to the default instance of `NSUbiquitousKeyValueStore`.
    /// This is used to store key-value pairs in iCloud, allowing them to be shared across the user's devices.
    ///
    /// - Note: This instance is used outside of this class as well.
    let kvs = NSUbiquitousKeyValueStore.default

    /// An enumeration representing different prefixes.
    /// Conforms to `String` and `CaseIterable` protocols.
    enum Prefix: String, CaseIterable {
        /// Represents the key for application settings in the settings manager.
        /// This case is used to identify and access the app settings stored in the application.
        /// - Note: The raw value for this case is "AppSettings".
        case appSettings = "AppSettings"

        /// Represents the key for settings related to the WhatsNewKit Swift Package.
        /// - Note: The raw value for this case is "WhatsNewKit".
        case whatsNewKit = "WhatsNewKit"

        /// Checks if the given key has a prefix that matches any of the raw values of the enum cases.
        /// - Parameter key: The string to check for a matching prefix.
        /// - Returns: A Boolean value indicating whether the key has a matching prefix.
        static func isPrefixMatching(key: String) -> Bool {
            Self.allCases.contains { key.hasPrefix($0.rawValue) }
        }

        /// Generates a unique key for UserDefaults based on the provided `UDKVSKeys` enum value.
        /// - Parameter key: The `UDKVSKeys` enum value to be used for generating the key.
        /// - Returns: A `String` representing the unique key for UserDefaults.
        fileprivate func udfKey(for key: UDKVSKeys) -> String {
            "\(self.rawValue)-\(key.rawValue)"
        }
    }

    /// An enumeration representing the keys used for storing values in UserDefaults.
    /// Each case corresponds to a specific key used in the app's settings.
    ///
    /// - Note: The raw value of each case is a PascalCase `String` representing the actual key.
    fileprivate enum UDKVSKeys: String {
        case firstLaunch = "FirstLaunch"
        case location = "Location"
        case debugMode = "DebugMode"
        case onboarding = "Onboarding"
        case screenshotMode = "ScreenshotMode"
        case hideMensaWithNoMenus = "HideMensaWithNoMenus"
        case mensaCellType = "MensaCellType"
        case priceType = "PriceType"
        case notifications = "Notifications"
        case notificationsSound = "NotificationsSound"
        case sortBy = "SortBy"
        case notificationsTime = "NotificationsTime"
        case mensaShowType = "MensaShowType"
        case campusType = "CampusType"
        case cloudKitForSettings = "CloudKitForSettings"
        case showAllergens = "ShowAllergens"
        case allergens = "Allergens"
    }

#if !APPCLIP && !os(watchOS) && !os(visionOS)
    /// A published property that indicates the location setting.
    @Published var location: Bool
#endif

    /// A published property indicating whether the first launch has been completed.
    @Published var completedFirstLaunch: Bool

    /// A boolean value indicating whether the debug mode is enabled.
    @Published var debugMode: Bool

    /// A boolean value indicating whether the onboarding process is completed.
    @Published var completedOnboarding: Bool

    /// A boolean value indicating whether the screenshot mode is enabled.
    @Published var screenshotMode: Bool

    /// A boolean value indicating whether to hide mensa with no menus.
    @Published var hideMensaWithNoMenus: Bool

    /// The type of mensa cell to be displayed.
    @Published var mensaCellType: MensaCellType

    /// The type of price to be displayed.
    @Published var priceType: PriceType

    /// A boolean value indicating whether notifications are enabled.
    @Published var notifications: Bool

    /// The sound to be used for notifications.
    @Published var notificationsSound: String

    /// The type of sorting to be applied.
    @Published var sortBy: SortType

    /// The time at which notifications should be sent.
    ///
    /// - Important: This property uses a `Date` instead of `DateComponents` because of SwiftUI's DatePicker.
    @Published var notificationsTime: Date

    /// The type of mensa show to be displayed.
    @Published var mensaShowType: MensaShowType

    /// The type of mensa location to be displayed.
    @Published var mensaLocationType: Campus.CampusType

    /// A boolean value indicating whether CloudKit is enabled for settings.
    @Published var cloudkitForSettings: Bool

    /// A boolean value indicating whether to show allergens.
    @Published var showAllergens: Bool

    /// A list of allergens to be displayed.
    @Published var allergens: [Allergen]

    /// Computed helper variables for mapping filters to their UI representation

    var filterOpenOnly: Bool {
        get { mensaShowType == .open }
        set { mensaShowType = newValue ? .open : .all }
    }
        
    var sortAlphabetically: Bool {
        get { sortBy == .name }
        set { sortBy = newValue ? .name : .def }
    }
    
    var filterCampus: Campus.CampusType? {
        get { mensaLocationType != .all ? mensaLocationType : nil }
        set { mensaLocationType = newValue ?? .all }
    }
    
    /// A set of AnyCancellable objects that represent the subscribers to the settings manager.
    /// These subscribers are used to manage and cancel Combine subscriptions when they are no longer needed.
    private var subscribers: Set<AnyCancellable> = []

    // swiftlint:disable:next function_body_length
    init() {
        completedFirstLaunch = udf.bool(forKey: Prefix.appSettings.udfKey(for: .firstLaunch))
#if !APPCLIP && !os(watchOS) && !os(visionOS)
        location = udf.bool(forKey: Prefix.appSettings.udfKey(for: .location))
#endif
        debugMode = udf.bool(forKey: Prefix.appSettings.udfKey(for: .debugMode))
        completedOnboarding = udf.bool(forKey: Prefix.appSettings.udfKey(for: .onboarding))
        screenshotMode = udf.bool(forKey: Prefix.appSettings.udfKey(for: .screenshotMode))
        hideMensaWithNoMenus = udf.bool(
            forKey: Prefix.appSettings.udfKey(for: .hideMensaWithNoMenus)
        )
        mensaCellType = MensaCellType(
            rawValue: udf.string(
                forKey: Prefix.appSettings.udfKey(for: .mensaCellType)
            ) ?? MensaCellType.standard.rawValue
        )!
        priceType = PriceType(
            rawValue: udf.string(
                forKey: Prefix.appSettings.udfKey(for: .priceType)
            ) ?? PriceType.all.rawValue
        )!
        notifications = udf.bool(forKey: Prefix.appSettings.udfKey(for: .notifications))
        if let notificationsSound = kvs.string(
            forKey: Prefix.appSettings.udfKey(for: .notificationsSound)
        ) {
            self.notificationsSound = notificationsSound
        } else {
            kvs.set("default", forKey: Prefix.appSettings.udfKey(for: .notificationsSound))
            self.notificationsSound = "default"
        }
        if let sortByRaw = kvs.string(forKey: Prefix.appSettings.udfKey(for: .sortBy)),
           let sortBy = SortType(rawValue: sortByRaw) {
            self.sortBy = sortBy
        } else {
            kvs.set(SortType.def.rawValue, forKey: Prefix.appSettings.udfKey(for: .sortBy))
            self.sortBy = .def
        }
        if let array = kvs.array(forKey: Prefix.appSettings.udfKey(for: .notificationsTime)),
           let hour = array[0] as? Int, let minute = array[1] as? Int,
           let notificationsTime = Date.fromInt(hour: hour, minute: minute) {
            self.notificationsTime = notificationsTime
        } else {
            kvs.set([11, 0], forKey: Prefix.appSettings.udfKey(for: .notificationsTime))
            self.notificationsTime = .fromInt(hour: 11, minute: 0)!
        }
        if let mensaShowTypeRaw = kvs.string(
            forKey: Prefix.appSettings.udfKey(for: .mensaShowType)
        ),
           let mensaShowType = MensaShowType(rawValue: mensaShowTypeRaw) {
            self.mensaShowType = mensaShowType
        } else {
            kvs.set(
                MensaShowType.all.rawValue,
                forKey: Prefix.appSettings.udfKey(for: .mensaShowType)
            )
            self.mensaShowType = .all
        }
        if let mensaLocationTypeRaw = kvs.string(
            forKey: Prefix.appSettings.udfKey(for: .campusType)
        ),
           let mensaLocationType = Campus.CampusType(rawValue: mensaLocationTypeRaw) {
            self.mensaLocationType = mensaLocationType
        } else {
            kvs.set(
                Campus.CampusType.all.rawValue,
                forKey: Prefix.appSettings.udfKey(for: .campusType)
            )
            self.mensaLocationType = .all
        }
        mensaLocationType = Campus.CampusType(
            rawValue: udf.string(
                forKey: Prefix.appSettings.udfKey(for: .campusType)
            ) ?? Campus.CampusType.all.rawValue
        )!
        cloudkitForSettings = udf.bool(
            forKey: Prefix.appSettings.udfKey(for: .cloudKitForSettings)
        )
        showAllergens = kvs.bool(forKey: Prefix.appSettings.udfKey(for: .showAllergens))
        if let allergensRaw = kvs.array(
            forKey: Prefix.appSettings.udfKey(for: .allergens)
        ) as? [String] {
            self.allergens = allergensRaw.compactMap { Allergen(rawValue: $0) }
        } else {
            udf.set([], forKey: Prefix.appSettings.udfKey(for: .allergens))
            self.allergens = []
        }
        setupCombine()
        synchronize()
    }

    // swiftlint:disable:next orphaned_doc_comment
    /// Sets up Combine publishers to synchronize with UserDefaults or Key-Value Storage.
    /// This method binds the published variables to the respective storage mechanisms,
    /// ensuring that changes are persisted and can be observed.
    // swiftlint:disable:next function_body_length
    private func setupCombine() {
        $completedFirstLaunch.sink { newValue in
            self.udf.set(
                newValue,
                forKey: Prefix.appSettings.udfKey(for: .firstLaunch)
            )
        }.store(in: &subscribers)
#if !APPCLIP && !os(watchOS) && !os(visionOS)
        $location.sink { newValue in
            if newValue {
                GeofencingManager.shared.startGeofencingManager()
            } else {
                GeofencingManager.shared.stopGeofencingManager()
            }
            self.udf.set(
                newValue,
                forKey: Prefix.appSettings.udfKey(for: .location)
            )
        }.store(in: &subscribers)
        $debugMode.sink { newValue in
            if newValue {
                self.udf.set(
                    newValue,
                    forKey: Prefix.appSettings.udfKey(for: .debugMode)
                )
            }
        }.store(in: &subscribers)
        $completedOnboarding.sink { newValue in
            self.udf.set(
                newValue,
                forKey: Prefix.appSettings.udfKey(for: .onboarding)
            )
        }.store(in: &subscribers)
        $screenshotMode.sink { newValue in
            self.udf.set(
                newValue,
                forKey: Prefix.appSettings.udfKey(for: .screenshotMode)
            )
        }.store(in: &subscribers)
        $hideMensaWithNoMenus.sink { newValue in
            self.udf.set(
                newValue,
                forKey: Prefix.appSettings.udfKey(for: .hideMensaWithNoMenus)
            )
        }.store(in: &subscribers)
        $mensaCellType.sink { newValue in
            self.udf.set(
                newValue.rawValue,
                forKey: Prefix.appSettings.udfKey(for: .mensaCellType)
            )
        }.store(in: &subscribers)
        $priceType.sink { newValue in
            self.udf.set(
                newValue.rawValue,
                forKey: Prefix.appSettings.udfKey(for: .priceType)
            )
        }.store(in: &subscribers)
        $notifications.sink { newValue in
            self.udf.set(
                newValue,
                forKey: Prefix.appSettings.udfKey(for: .notifications)
            )
        }.store(in: &subscribers)
        $notificationsSound.sink { newValue in
            self.kvs.set(
                newValue,
                forKey: Prefix.appSettings.udfKey(for: .notificationsSound)
            )
            self.synchronize()
        }.store(in: &subscribers)
        $sortBy.sink { newValue in
            self.udf.set(
                newValue.rawValue,
                forKey: Prefix.appSettings.udfKey(for: .sortBy)
            )
            self.synchronize()
        }.store(in: &subscribers)
        $notificationsTime.sink { newValue in
            self.kvs.set(
                [newValue.hour, newValue.minute],
                forKey: Prefix.appSettings.udfKey(for: .notificationsTime)
            )
            self.synchronize()
        }.store(in: &subscribers)
        $mensaShowType.sink { newValue in
            self.kvs.set(
                newValue.rawValue,
                forKey: Prefix.appSettings.udfKey(for: .mensaShowType)
            )
            self.synchronize()
        }.store(in: &subscribers)
        $mensaLocationType.sink { newValue in
            self.kvs.set(
                newValue.rawValue,
                forKey: Prefix.appSettings.udfKey(for: .campusType)
            )
            self.synchronize()
        }.store(in: &subscribers)
        $cloudkitForSettings.sink { newValue in
            self.udf.set(
                newValue,
                forKey: Prefix.appSettings.udfKey(for: .cloudKitForSettings)
            )
        }.store(in: &subscribers)
        $showAllergens.sink { newValue in
            self.kvs.set(
                newValue,
                forKey: Prefix.appSettings.udfKey(for: .showAllergens)
            )
            self.synchronize()
        }.store(in: &subscribers)
        $allergens.sink { newValue in
            self.kvs.set(
                newValue.map(\.rawValue),
                forKey: Prefix.appSettings.udfKey(for: .allergens)
            )
            self.synchronize()
        }.store(in: &subscribers)
#endif
    }

    /// Synchronizes the settings with the cloud if the `cloudkitForSettings` flag is enabled.
    /// If `cloudkitForSettings` is true, it calls the `synchronize` method on the `kvs` object.
    func synchronize() {
        if cloudkitForSettings {
            kvs.synchronize()
        }
    }

#if !APPCLIP && !os(watchOS)
    /// Resets OS permissions if needed by checking the authorization status of notifications and location services.
    ///
    /// This function performs the following checks:
    /// - If notification permissions are not authorized, it sets the `notifications` property to `false`.
    /// - If location permissions are not authorized (except on visionOS), it sets the `location` property to `false`.
    ///
    /// - Important: This function does not apply to App Clips and watchOS.
    func osPermissionsResetIfNeeded() async {
        if await UNUserNotificationCenter
            .current()
            .notificationSettings()
            .authorizationStatus != .authorized {
            await MainActor.run {
                notifications = false
            }
        }
#if !os(visionOS)
        if CLLocationManager()
            .authorizationStatus != .authorizedAlways {
            await MainActor.run {
                location = false
            }
        }
#endif
    }
#endif
}
