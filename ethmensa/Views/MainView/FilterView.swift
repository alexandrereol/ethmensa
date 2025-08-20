//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct FilterView: View {

    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        if (settingsManager.mensaShowType != .all ||
            settingsManager.sortBy != .def ||
            settingsManager.mensaLocationType != .all) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    FilterBubble(
                        value: $settingsManager.mensaShowType,
                        defaultValue: .all,
                        name: String(localized: "OPEN_ONLY")
                    )
                    FilterBubble(
                        value: $settingsManager.sortBy,
                        defaultValue: .def,
                        name: String(localized: "ALPHABETIC_SORTING")
                    )
                    FilterBubble(
                        value: $settingsManager.mensaLocationType,
                        defaultValue: .all,
                        name: settingsManager.mensaLocationType.localizedString
                    )
                }
                .environmentObject(navigationManager)
                .environmentObject(settingsManager)
            }
        }
    }
}

struct FilterBubble<T: Equatable>: View {
    @Binding var value: T
    let defaultValue: T
    let name: String

    var body: some View {
        if value != defaultValue {
            Button {
                withAnimation(.easeInOut) { value = defaultValue }
            } label: {
                HStack(spacing: 6) {
                    Text(name).font(.footnote.weight(.semibold))
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .accessibilityHidden(true)
                }
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .accessibilityLabel("Clear \(name)")
        }
    }
}

private extension View {
    func buttonStyle(selected: Bool) -> some View {
        Group {
            if selected {
                self
                    .buttonStyle(.bordered)
#if !os(visionOS)
                    .tint(.primary)
#endif
            } else {
                self
                    .buttonStyle(.borderedProminent)
                    .tint(.accentColor)
            }
        }
    }
}

#Preview("Filter") {
    FilterView()
        .environmentObject(NavigationManager.shared)
        .environmentObject(SettingsManager.shared)
}

#Preview("Sample Data") {
    MainView()
        .environmentObject(NavigationManager.example)
        .environmentObject(SettingsManager.shared)
}
