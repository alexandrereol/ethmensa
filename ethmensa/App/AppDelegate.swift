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

import AppIntents
import os.log
import UIKit

#if !APPCLIP && !os(visionOS)
import CoreLocation
#endif

class AppDelegate: NSObject, UIApplicationDelegate {
    internal let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: AppDelegate.self)
    )

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
#if !APPCLIP && !os(visionOS)
        ShortcutsProvider.updateAppShortcutParameters()
#endif
        // Add AppDependencyManager for AppIntents
        AppDependencyManager.shared.add(dependency: NavigationManager.shared)
        AppDependencyManager.shared.add(dependency: MensaDataManager.shared)
        AppDependencyManager.shared.add(dependency: SettingsManager.shared)
#if !APPCLIP
        UNUserNotificationCenter.current().delegate = self
        _ = SharedWithYouManager.shared
#endif
        NetworkManager.shared.startNwMonitoring()
        URLCache.shared.memoryCapacity = 10_000_000 // 10MB
        URLCache.shared.diskCapacity = 50_000_000 // 50MB
#if DEBUG
        URLCache.shared.removeAllCachedResponses()
#endif
        SettingsManager.shared.launchAndMigrate()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(
            name: nil,
            sessionRole: connectingSceneSession.role
        )
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}
