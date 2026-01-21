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

enum SheetType: String, Identifiable {
#if !APPCLIP && !WIDGET
    case settings
#endif
#if os(watchOS) && !WIDGET
    case filter
#endif
#if !os(watchOS) && !APPCLIP && !WIDGET
    case notificationSettings
#endif
#if !os(watchOS) && !os(visionOS) && !APPCLIP && !targetEnvironment(macCatalyst)
    case legiCard
#endif

    // Needed to prevent compile error
    case unused

    var id: String {
        rawValue
    }
}

struct AppViewSheets: View {

    @EnvironmentObject var navigationManager: NavigationManager

#if !WIDGET
    @EnvironmentObject var settingsManager: SettingsManager
#endif

    var type: SheetType

    var body: some View {
        Group {
            switch type {
#if !APPCLIP && !WIDGET
            case .settings:
                SettingsView()
                    .environmentObject(settingsManager)
#endif
#if os(watchOS) && !WIDGET
            case .filter:
                FilterView()
#endif
#if !os(watchOS) && !APPCLIP && !WIDGET
            case .notificationSettings:
                NavigationStack {
                    SettingsNotificationsView()
                        .environmentObject(settingsManager)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("CLOSE") {
                                    navigationManager.sheet = nil
                                }
                            }
                        }
                }
#endif
#if !os(watchOS) && !os(visionOS) && !APPCLIP && !targetEnvironment(macCatalyst)
            case .legiCard:
                LegiView()
#endif
            case .unused:
                // Needed to prevent compile error
                EmptyView()
            }
        }
        .environmentObject(navigationManager)
    }
}
