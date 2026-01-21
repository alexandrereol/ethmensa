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

struct SettingsGeneralView: View {

    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        Section("GENERAL") {
            SettingsCellView(
                label: .init(localized: "LANGUAGE"),
                systemImageName: "globe.fill"
            ) {
                SettingsLanguageSelectionView()
            }
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
