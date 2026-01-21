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
                    Toggle(
                        "ENABLE_NOTIFICATIONS",
                        isOn: $viewModel.notifications.animation()
                    )
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
