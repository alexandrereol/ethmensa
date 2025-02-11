//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Foundation

extension SettingsManager {
    /// Launches the application and performs necessary migrations.
    /// 
    /// This method checks if the application has completed its first launch. If not, it performs the following actions:
    /// - For visionOS and watchOS, it sets `completedFirstLaunch` to true as these platforms do not have onboarding.
    /// - For watchOS, it enables CloudKit for settings and synchronizes them.
    /// - For other platforms, it checks if the ubiquity identity token is available to enable CloudKit for settings
    ///   and synchronize them.
    ///
    /// Additionally, if the app is not running as an App Clip, on watchOS, or on visionOS, it starts or stops the
    /// Geofencing Manager based on the `location` setting.
    ///
    /// Finally, it calls `migrateIfNeeded()` to perform any necessary migrations.
    func launchAndMigrate() {
        if !completedFirstLaunch {
#if os(visionOS) || os(watchOS)
            // Needed as visionOS and watchOS do not have Onboarding
            completedFirstLaunch = true
#endif
#if os(watchOS)
            cloudkitForSettings = true
            synchronize()
#else
            if FileManager.default.ubiquityIdentityToken != nil {
                cloudkitForSettings = true
                synchronize()
            }
#endif
        }
#if !APPCLIP && !os(watchOS) && !os(visionOS)
        if location {
            GeofencingManager.shared.startGeofencingManager()
        } else {
            GeofencingManager.shared.stopGeofencingManager()
        }
#endif
        migrateIfNeeded()
    }

    /// Checks if a migration is needed and performs the migration if necessary.
    private func migrateIfNeeded() {
        // Removed sort option popular from 5.5 -> 6.0
        if let raw = udf.string(forKey: "\(Prefix.appSettings.rawValue)-SortBy"),
           raw == "popular" {
            udf.set(SortType.def.rawValue, forKey: "\(Prefix.appSettings.rawValue)-SortBy")
        }

        // Removed option to set favourite mensas from 5.5 -> 6.0
        if let array = udf.array(forKey: "\(Prefix.appSettings.rawValue)-FavoriteMensas") as? [Int] {
            udf.removeObject(forKey: "\(Prefix.appSettings.rawValue)-FavoriteMensas")
            for index in array {
                udf.set(10, forKey: "ClicksCount-\(index)")
            }
        }

        // Removed option to customize interactive mensas from 5.5 -> 6.0
        if udf.array(forKey: "\(Prefix.appSettings.rawValue)-NotificationsMensas-1") is [Int],
           udf.array(forKey: "\(Prefix.appSettings.rawValue)-NotificationsMensas-2") is [Int] {
            udf.removeObject(forKey: "\(Prefix.appSettings.rawValue)-NotificationsMensas-1")
            udf.removeObject(forKey: "\(Prefix.appSettings.rawValue)-NotificationsMensas-2")
        }

        // Removed options from 6.0 -> 6.1
        if kvs.bool(forKey: "\(Prefix.appSettings.rawValue)-ImageSearch") {
            kvs.removeObject(forKey: "\(Prefix.appSettings.rawValue)-ImageSearch")
        }
        if kvs.string(forKey: "\(Prefix.appSettings.rawValue)-SearchEngine") != nil {
            kvs.removeObject(forKey: "\(Prefix.appSettings.rawValue)-SearchEngine")
        }
        if kvs.string(forKey: "\(Prefix.appSettings.rawValue)-MenuViews") != nil {
            kvs.removeObject(forKey: "\(Prefix.appSettings.rawValue)-MenuViews")
        }
    }
}
