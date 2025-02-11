//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct SettingsNotificationsView: View {

    @EnvironmentObject var settingsManager: SettingsManager

    @StateObject private var viewModel = SettingsNotificationsViewModel()

    private var selectedSoundString: String {
        Sound.all.first(
            where: {
                $0.id == settingsManager.notificationsSound
            }
        )?.localizedName ?? .init(localized: "DEFAULT")
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("ENABLE_NOTIFICATIONS", isOn: $viewModel.notifications.animation())
                        .tint(.accent)
                        .permissionAlerts(
                            localizedDeniedPermission: .init(localized: "NOTIFICATIONS"),
                            deniedShown: $viewModel.notificationDeniedAlertShown,
                            notSupportedShown: $viewModel.notificationNotSupportedAlertShown,
                            deniedSettingsAction: {
                                viewModel.deniedAction()
                            }
                        )
                } footer: {
                    Text("ENABLE_NOTIFICATIONS_FOOTER")
                }
                if viewModel.notifications {
                    Section {
                        NavigationLink {
                            SoundSelectionView()
                                .environmentObject(settingsManager)
                        } label: {
                            LabeledContent("NOTIFICATION_SOUND") {
                                Text(selectedSoundString)
                            }
                        }
                        DatePicker(
                            "TIME_OF_NOTIFICATIONS",
                            selection: $settingsManager.notificationsTime,
                            displayedComponents: .hourAndMinute
                        )
                    } footer: {
                        Text("TIME_OF_NOTIFICATIONS_FOOTER")
                    }
#if !os(visionOS)
                    Section {
                        Toggle("LOCATIONS_BASED_NOTIFICATIONS", isOn: $viewModel.location)
                            .tint(.accent)
                            .permissionAlerts(
                                localizedDeniedPermission: .init(localized: "LOCATION"),
                                deniedShown: $viewModel.notificationDeniedAlertShown,
                                notSupportedShown: $viewModel.notificationNotSupportedAlertShown,
                                deniedSettingsAction: {
                                    viewModel.deniedAction()
                                }
                            )
                    } footer: {
                        Text("LOCATIONS_BASED_NOTIFICATIONS_FOOTER")
                    }
#endif
                }
            }
            .navigationTitle("NOTIFICATIONS")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsNotificationsView()
            .environmentObject(SettingsManager.shared)
    }
}
