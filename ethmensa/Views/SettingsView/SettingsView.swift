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

struct SettingsView: View {

    @Environment(\.dismiss) private var dismiss

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
