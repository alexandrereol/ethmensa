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

struct AppView: View {

    @Environment(\.openURL) private var openURL

    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var mensaDataManager: MensaDataManager
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        // The onboarding cover sits on its own view level (a real container,
        // not a transparent Group): one view can't present two covers at
        // once, so it must not share the chain below with the offline /
        // incompatible-version / image covers.
        ZStack {
            NavigationSplitView {
                MainView()
            } detail: {
                DetailView()
            }
            .environmentObject(navigationManager)
            .environmentObject(mensaDataManager)
            .environmentObject(settingsManager)
            .fullScreenCover(isPresented: $networkManager.isOffline) {
                ModalViewUI(viewModel: .noInternet)
            }
            .versionIncompatibleIfNeeded(
                host: API.shared.host,
                tintColor: .accent,
                appIcon: .appIconRoundedForUserVersion
            ) {
                openURL(String.appStoreURLString.toURL()!)
            } detailButtonAction: {
                openURL(String.automaticUpdatesURLString.toURL()!)
            }
#if APPCLIP
            .skOverlay()
#elseif canImport(WhatsNewKit)
            .whatsNewSheet()
#endif
            .openURL(
                universalLinkAlertShown: $navigationManager.universalLinkAlertShown,
                universalLinkMensaId: $navigationManager.universalLinkMensaId
            )
            .sheet(item: $navigationManager.sheet) { type in
                AppViewSheets(type: type)
                    .environmentObject(navigationManager)
                    .environmentObject(settingsManager)
            }
            .fullScreenCover(isPresented: $navigationManager.imagePopoverShown) {
                if let url = navigationManager.imagePopoverURL {
                    FullscreenImageView(url: url)
                }
            }
        }
#if !APPCLIP && !os(visionOS)
        .onboardingFullScreenCoverIfNecessary(
            isPending: !settingsManager.completedFirstLaunch
        ) {
            settingsManager.completedFirstLaunch = true
        }
#endif
    }
}

#Preview {
    AppView()
        .environmentObject(NavigationManager.shared)
        .environmentObject(MensaDataManager.shared)
        .environmentObject(SettingsManager.shared)
}
