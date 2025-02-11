//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

enum SheetType: String, Identifiable {
#if !APPCLIP
    case settings
#endif
#if os(watchOS)
    case filter
#endif
#if !os(watchOS) && !APPCLIP
    case notificationSettings
#endif

    // Needed to prevent compile error
    case unused

    var id: String {
        rawValue
    }
}

struct AppViewSheets: View {

    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var settingsManager: SettingsManager

    var type: SheetType

    var body: some View {
        Group {
            switch type {
#if !APPCLIP
            case .settings:
                SettingsView()
#endif
#if os(watchOS)
            case .filter:
                FilterView()
#endif
#if !os(watchOS) && !APPCLIP
            case .notificationSettings:
                NavigationStack {
                    SettingsNotificationsView()
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("CLOSE") {
                                    navigationManager.sheet = nil
                                }
                            }
                        }
                }
#endif
            case .unused:
                // Needed to prevent compile error
                EmptyView()
            }
        }
        .environmentObject(navigationManager)
        .environmentObject(settingsManager)
    }
}
