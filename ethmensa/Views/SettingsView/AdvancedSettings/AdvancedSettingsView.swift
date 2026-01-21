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

struct AdvancedSettingsView: View {

    @StateObject var viewModel = AdvancedSettingsViewModel()

    var body: some View {
        List {
            Section {
                Button("RESET_SMART_SORTING") {
                    viewModel.resetSmartSortingAlertShown = true
                }
                .advancedSettingsAlert(
                    isPresented: $viewModel.resetSmartSortingAlertShown,
                    title: "\(String(localized: "RESET_SMART_SORTING"))?"
                ) {
                    viewModel.resetSmartSorting()
                }
                Button("RESET_MAPS_CACHE") {
                    viewModel.resetAppleMapsCacheAlertShown = true
                }
                .advancedSettingsAlert(
                    isPresented: $viewModel.resetAppleMapsCacheAlertShown,
                    title: "\(String(localized: "RESET_MAPS_CACHE"))?"
                ) {
                    viewModel.resetAppleMapsCache()
                }
            } header: {
                Text(String(localized: "ADVANCED_SETTINGS_FOOTER_MESSAGE") + "\n")
                    .foregroundStyle(.red)
            }
            Section {
                Button("RESET_SETTINGS") {
                    viewModel.resetSettingsAlertShown = true
                }
                .advancedSettingsAlert(
                    isPresented: $viewModel.resetSettingsAlertShown,
                    title: "\(String(localized: "RESET_SETTINGS"))?"
                ) {
                    viewModel.resetSettings()
                }
                Button("RESET_SETTINGS_AND_DATA") {
                    viewModel.resetSettingsAndDataAlertShown = true
                }
                .advancedSettingsAlert(
                    isPresented: $viewModel.resetSettingsAndDataAlertShown,
                    title: "\(String(localized: "RESET_SETTINGS_AND_DATA"))?"
                ) {
                    viewModel.resetSettingsAndData()
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AdvancedSettingsView()
}
