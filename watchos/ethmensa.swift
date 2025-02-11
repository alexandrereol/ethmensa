//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

@main
// swiftlint:disable:next type_name
struct ethmensa: App {

    @WKApplicationDelegateAdaptor(AppDelegate.self) var delegate: AppDelegate

    @StateObject var mensaDataManager = MensaDataManager.shared
    @StateObject var navigationManager = NavigationManager.shared
    @StateObject var settingsManager = SettingsManager.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(mensaDataManager)
                .environmentObject(navigationManager)
                .environmentObject(settingsManager)
        }
    }
}
