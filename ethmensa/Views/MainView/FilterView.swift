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

/// Shows every active filter as a chip that removes the filter when tapped.
/// Filters are added through the filter menu in the toolbar.
struct FilterView: View {

    // Observed so the chips update whenever a filter changes, as `MensaFilter.active` reads the shared managers.
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(MensaFilter.active) { filter in
                    FilterChipView(filter: filter)
                }
            }
            // Keeps a chip that is being removed in place while the header collapses, instead of re-centring it.
            .frame(maxHeight: .infinity, alignment: .top)
            .environmentObject(navigationManager)
            .environmentObject(settingsManager)
        }
        .scrollClipDisabledIfAvailable()
    }
}

private struct FilterChipView: View {

    let filter: MensaFilter

    var body: some View {
        Button {
            withAnimation {
                filter.remove()
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: filter.systemImageName)
                Text(filter.localizedString)
                Image(systemName: "xmark")
                    .font(.caption.weight(.bold))
            }
            .font(.subheadline.weight(.semibold))
        }
        .buttonBorderShape(.capsule)
        .buttonStyle(selected: false)
        .accessibilityLabel(filter.localizedString)
        .accessibilityHint("REMOVES_THIS_FILTER")
    }
}

private extension View {
    /// Lets a chip grow past the scroll view's bounds while it animates on press,
    /// instead of being cut off at the top and bottom.
    @ViewBuilder
    func scrollClipDisabledIfAvailable() -> some View {
        if #available(iOS 17.0, *) {
            self.scrollClipDisabled()
        } else {
            self
        }
    }

    /// Styles a filter chip. `selected` is true while the filter is at its default value;
    /// an active (non-default) filter is shown prominently in the accent colour.
    /// On iOS 26 and later the chips use Liquid Glass. The glass styles are not
    /// available on visionOS, whose bordered buttons are already glass.
    @ViewBuilder
    func buttonStyle(selected: Bool) -> some View {
#if !os(visionOS)
        if #available(iOS 26.0, *) {
            if selected {
                self
                    .buttonStyle(.glass)
            } else {
                self
                    .buttonStyle(.glassProminent)
                    .tint(.accentColor)
            }
        } else {
            legacyButtonStyle(selected: selected)
        }
#else
        legacyButtonStyle(selected: selected)
#endif
    }

    @ViewBuilder
    private func legacyButtonStyle(selected: Bool) -> some View {
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
