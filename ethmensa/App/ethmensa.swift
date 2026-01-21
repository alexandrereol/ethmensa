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
