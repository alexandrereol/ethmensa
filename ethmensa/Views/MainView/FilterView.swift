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
        .accessibilityLabel(
            "\(String(localized: "OPENING_TIME_FILTER")): \(settingsManager.mensaShowType.localizedString)"
        )
        .accessibilityHint(String(localized: "DOUBLE_TAP_TO_CHANGE_FILTER"))
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
        .accessibilityLabel(
            "\(String(localized: "LOCATION_FILTER")): \(settingsManager.mensaLocationType.localizedString)"
        )
        .accessibilityHint(String(localized: "DOUBLE_TAP_TO_CHANGE_FILTER"))
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
        .accessibilityLabel(
            "\(String(localized: "SORT_FILTER")): \(settingsManager.sortBy.localizedString)"
        )
        .accessibilityHint(String(localized: "DOUBLE_TAP_TO_CHANGE_FILTER"))
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
            .accessibilityLabel(
                "\(String(localized: "WEEKDAY_FILTER")): \(menuString)"
            )
            .accessibilityHint(String(localized: "DOUBLE_TAP_TO_CHANGE_FILTER"))
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
