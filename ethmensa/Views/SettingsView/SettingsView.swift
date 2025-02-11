//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct SettingsView: View {

    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        NavigationStack {
            List {
                SettingsGeneralView()
                SettingsAppearanceView()
                SettingsiCloudView()
                SettingsCellView(label: .init(localized: "ADVANCED_SETTINGS")) {
                    AdvancedSettingsView()
                }
//                SettingsETHVideoView()
                SettingsFooterView()
            }
            .environmentObject(settingsManager)
            .navigationTitle("SETTINGS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("CLOSE") {
                        dismiss()
                    }
                    .keyboardShortcut(.cancelAction)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsManager.shared)
}
