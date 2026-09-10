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

struct FilterView: View {

    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                OpeningTimeFilterButtonView()
                LocationFilterButtonView()
                SortTypeButtonView()
                WeekdayButtonView()
            }
            .environmentObject(navigationManager)
            .environmentObject(settingsManager)
        }
        .scrollClipDisabledIfAvailable()
    }
}

private struct OpeningTimeFilterButtonView: View {

    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        Menu(settingsManager.mensaShowType.localizedString) {
            Picker(
                String(""),
                selection: $settingsManager.mensaShowType.animation()
            ) {
                ForEach(MensaShowType.allCases, id: \.rawValue) { showType in
                    Text(showType.localizedString).tag(showType)
                }
            }
        }
        .buttonBorderShape(.capsule)
        .buttonStyle(
            selected: settingsManager.mensaShowType == .all
        )
    }
}

private struct LocationFilterButtonView: View {

    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        Menu(settingsManager.mensaLocationType.localizedString) {
            Picker(
                String(""),
                selection: $settingsManager.mensaLocationType.animation()
            ) {
                ForEach(Campus.CampusType.allCases, id: \.rawValue) { showType in
                    Text(showType.localizedString).tag(showType)
                }
            }
        }
        .buttonBorderShape(.capsule)
        .buttonStyle(
            selected: settingsManager.mensaLocationType == .all
        )
    }
}

private struct SortTypeButtonView: View {

    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        Menu(settingsManager.sortBy.localizedString) {
            Picker(
                String(""),
                selection: $settingsManager.sortBy.animation()
            ) {
                ForEach(SortType.allCases, id: \.rawValue) { showType in
                    Text(showType.localizedString).tag(showType)
                }
            }
        }
        .buttonBorderShape(.capsule)
        .buttonStyle(
            selected: settingsManager.sortBy == .def
        )
    }
}

private struct WeekdayButtonView: View {

    @EnvironmentObject var navigationManager: NavigationManager

    private var menuString: String {
        Date.weekdaysStartingAtOne.first { (index, _) in
            index == navigationManager.selectedWeekdayCodeOverride
        }?.1 ?? .init(localized: "WEEKDAY")
    }

    var body: some View {
        if !SettingsManager.shared.allergens.isEmpty {
            Menu(menuString) {
                Picker(
                    String(""),
                    selection: $navigationManager.selectedWeekdayCodeOverride.animation()
                ) {
                    Text("NO_WEEKDAY_ALLERGEN_FILTER").tag(Int?(nil))
                    ForEach(Date.weekdaysStartingAtOne, id: \.0) { (index, weekday) in
                        Text(weekday).tag(index)
                    }
                }
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(
                selected: navigationManager.selectedWeekdayCodeOverride == nil
            )
        }
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
