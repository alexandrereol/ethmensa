//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import os.log
import UIKit
import AppIntents

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
