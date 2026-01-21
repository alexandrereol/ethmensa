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

struct SettingsiCloudView: View {

    @EnvironmentObject var settingsManager: SettingsManager

    @State private var cloudkitUnavailableSafariCoverShown = false

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
                        NavigationLink(String("")) {
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
