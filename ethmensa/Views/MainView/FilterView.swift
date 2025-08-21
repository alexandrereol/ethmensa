//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct FilterView: View {

    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                FilterBubble(
                    value: $settingsManager.filterOpenOnly,
                    defaultValue: false,
                    name: String(localized: "OPEN_ONLY")
                )
                FilterBubble(
                    value: $settingsManager.sortAlphabetically,
                    defaultValue: false,
                    name: String(localized: "ALPHABETIC_SORTING")
                )
                FilterBubble(
                    value: $settingsManager.filterCampus,
                    defaultValue: nil,
                    name: settingsManager.mensaLocationType.localizedString
                )
            }
            .environmentObject(navigationManager)
            .environmentObject(settingsManager)
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
                withAnimation {
                    value = defaultValue
                }
            } label: {
                HStack(spacing: 6) {
                    Text(name).font(.footnote.weight(.semibold))
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .accessibilityHidden(true)
                }
            }
            .buttonStyle(.borderedProminent)
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
