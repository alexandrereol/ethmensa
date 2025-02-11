//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
