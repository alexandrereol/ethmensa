//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

#if canImport(WhatsNewKit)
import WhatsNewKit
#endif

@main
// swiftlint:disable:next type_name
struct ethmensa: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject var mensaDataManager = MensaDataManager.shared
    @StateObject var navigationManager = NavigationManager.shared
    @StateObject var networkManager = NetworkManager.shared
    @StateObject var settingsManager = SettingsManager.shared

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(navigationManager)
                .environmentObject(mensaDataManager)
                .environmentObject(networkManager)
                .environmentObject(settingsManager)
#if os(visionOS)
                .frame(
                    minWidth: 800,
                    maxWidth: 2000,
                    minHeight: 800,
                    maxHeight: 2000
                )
#endif
        }
#if os(visionOS)
        .windowResizability(.contentSize)
#endif
#if !APPCLIP
        .environment(
            \.whatsNew,
             WhatsNewEnvironment(
                versionStore: NSUbiquitousKeyValueWhatsNewVersionStore(
                    ubiquitousKeyValueStore: SettingsManager.shared.kvs
                ),
                whatsNewCollection: WhatsNewProvider()
             )
        )
#endif
    }
}
