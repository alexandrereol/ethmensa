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

import ImageViewerRemote
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

    @State private var showOnboarding = !SettingsManager.shared.completedFirstLaunch

    var body: some View {
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
#if !APPCLIP && !os(visionOS)
        .onboardingFullScreenCoverIfNecessary(
            showOnboarding: $showOnboarding
        ) {
            settingsManager.completedFirstLaunch = true
        }
#endif
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
        .overlay {
            ImageViewerRemote(
                imageURL: $navigationManager.imagePopoverURLString,
                viewerShown: $navigationManager.imagePopoverShown,
                disableCache: false
            )
            if navigationManager.imagePopoverShown {
                Button(String("")) {
                    navigationManager.imagePopoverShown = false
                }
                .opacity(0)
                .keyboardShortcut(.escape, modifiers: [])
                .accessibilityHidden(true)
                // A separate fully accessible dismiss button for VoiceOver users
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            navigationManager.imagePopoverShown = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundStyle(.white)
                                .padding()
                        }
                        .accessibilityLabel(String(localized: "DISMISS_IMAGE_VIEWER"))
                        .accessibilityAddTraits(.isButton)
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    AppView()
        .environmentObject(NavigationManager.shared)
        .environmentObject(MensaDataManager.shared)
        .environmentObject(SettingsManager.shared)
}
