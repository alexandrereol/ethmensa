//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
        .overlay(
            ImageViewerRemote(
                imageURL: $navigationManager.imagePopoverURLString,
                viewerShown: $navigationManager.imagePopoverShown,
                disableCache: false
            )
        )
    }
}

#Preview {
    AppView()
        .environmentObject(NavigationManager.shared)
        .environmentObject(MensaDataManager.shared)
        .environmentObject(SettingsManager.shared)
}
