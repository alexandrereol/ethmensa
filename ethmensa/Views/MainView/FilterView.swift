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
            ForEach(MensaShowType.allCases, id: \.rawValue) { showType in
                ButtonView(
                    localizedString: showType.localizedString,
                    selected: settingsManager.mensaShowType == showType
                ) {
                    withAnimation {
                        settingsManager.mensaShowType = showType
                    }
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
            ForEach(Campus.CampusType.allCases, id: \.rawValue) { showType in
                ButtonView(
                    localizedString: showType.localizedString,
                    selected: settingsManager.mensaLocationType == showType
                ) {
                    withAnimation {
                        settingsManager.mensaLocationType = showType
                    }
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
            ForEach(SortType.allCases, id: \.rawValue) { showType in
                ButtonView(
                    localizedString: showType.localizedString,
                    selected: settingsManager.sortBy == showType
                ) {
                    withAnimation {
                        settingsManager.sortBy = showType
                    }
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
                ButtonView(
                    localizedString: .init(localized: "NO_WEEKDAY_ALLERGEN_FILTER"),
                    selected: navigationManager.selectedWeekdayCodeOverride == nil
                ) {
                    withAnimation {
                        navigationManager.selectedWeekdayCodeOverride = nil
                    }
                }
                ForEach(Date.weekdaysStartingAtOne, id: \.0) { (index, weekday) in
                    ButtonView(
                        localizedString: weekday,
                        selected: navigationManager.selectedWeekdayCodeOverride == index
                    ) {
                        withAnimation {
                            navigationManager.selectedWeekdayCodeOverride = index
                        }
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

private struct ButtonView: View {

    var localizedString: String
    var selected: Bool
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            if selected {
                Label(localizedString, systemImage: "checkmark")
            } else {
                Text(localizedString)
            }
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
