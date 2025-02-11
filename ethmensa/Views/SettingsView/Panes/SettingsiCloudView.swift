//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct SettingsiCloudView: View {

    @EnvironmentObject var settingsManager: SettingsManager

    @State var cloudkitUnavailableSafariCoverShown = false

    private var cloudKitUnavailableURL: URL {
        String.iCloudUnavailableURL.toURL()!
    }

    var body: some View {
        if settingsManager.screenshotMode || FileManager.default.ubiquityIdentityToken != nil {
            Section {
                Toggle(
                    "SYNC_SETTINGS",
                    systemImage: "icloud.fill",
                    isOn: $settingsManager.cloudkitForSettings
                )
                .tint(.accentColor)
            } header: {
                Text("SYNCING_OVER_ICLOUD")
            } footer: {
                Text("SYNCING_OVER_ICLOUD_FOOTER")
            }
        } else {
            Section("SYNCING_OVER_ICLOUD") {
                Button {
                    cloudkitUnavailableSafariCoverShown = true
                } label: {
                    ZStack {
                        HStack {
                            Label("ICLOUD_UNAVAILABLE", systemImage: "icloud.slash.fill")
                            Spacer()
                        }
                        NavigationLink("") {
                            EmptyView()
                        }
                    }
                }
                .tint(.primary)
                .fullScreenCover(
                    isPresented: $cloudkitUnavailableSafariCoverShown
                ) {
                    SafariWebView(url: cloudKitUnavailableURL)
                        .ignoresSafeArea()
                }
            }
        }
    }
}

#Preview {
    List {
        SettingsiCloudView()
            .environmentObject(SettingsManager.shared)
    }
}
