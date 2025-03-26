//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
