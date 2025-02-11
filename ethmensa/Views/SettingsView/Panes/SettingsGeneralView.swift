//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct SettingsGeneralView: View {

    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        Section("GENERAL") {
            SettingsCellView(
                label: .init(localized: "NOTIFICATIONS"),
                systemImageName: "bell.badge.fill"
            ) {
                SettingsNotificationsView()
                    .environmentObject(settingsManager)
            }
            SettingsCellView(
                label: .init(localized: "ALLERGENS"),
                systemImageName: "exclamationmark.circle.fill"
            ) {
                SettingsAllergensView()
                    .environmentObject(settingsManager)
            }
        }
    }
}

#Preview {
    NavigationStack {
        List {
            SettingsGeneralView()
                .environmentObject(SettingsManager.shared)
        }
    }
}
