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
                "",
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
                "",
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
                "",
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
                    "",
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
