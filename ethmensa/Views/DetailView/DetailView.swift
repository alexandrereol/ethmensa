//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct DetailView: View {

    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var mensaDataManager: MensaDataManager

    private enum ViewState {
        case noSelection
        case noMenu
        case contentAvailable
    }

    private var viewState: ViewState {
        if navigationManager.selectedMensa == nil {
            .noSelection
        } else if mealTimes.isEmpty {
            .noMenu
        } else {
            .contentAvailable
        }
    }

    var contextMenuPreview = false

    private var mealTimes: [MealTime] {
        if let selectedMensa = navigationManager.selectedMensa {
            selectedMensa.mealTimes.filter { mealTime in
                mealTime.weekdayCode == navigationManager.selectedWeekdayCode
            }
        } else {
            []
        }
    }

    var body: some View {
        Group {
            switch viewState {
            case .noSelection:
                CustomContentUnavailableView(
                    label: .init(localized: "NO_MENSA_SELECTED"),
                    systemImageName: "frying.pan",
                    description: .init(localized: "NO_MENSA_SELECTED_MESSAGE"),
                    actions: { EmptyView() }
                )
            case .contentAvailable, .noMenu:
                List {
                    if !contextMenuPreview {
                        MapHeaderView()
                        WeekdaySelectorHeaderView()
                    }
                    if viewState == .noMenu {
                        Section {
                            CustomContentUnavailableView(
                                label: .init(localized: "NO_MENU"),
                                systemImageName: "frying.pan",
                                description: .init(localized: "NO_MENU_ON_THIS_DAY"),
                                actions: { EmptyView() }
                            )
                        }
                    } else if viewState == .contentAvailable {
                        ForEach(mealTimes) { mealTime in
                            Section(mealTime.type ?? .init(localized: "MEAL")) {
                                if navigationManager.selectedWeekdayCodeOverride != nil {
                                    ForEach(mealTime.allergenCompatibleMeals) { meal in
                                        MealCellView(meal: meal)
                                    }
                                } else {
                                    ForEach(mealTime.meals) { meal in
                                        MealCellView(meal: meal)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .environmentObject(navigationManager)
        .environmentObject(mensaDataManager)
        .navigationTitle(navigationManager.selectedMensa?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .clickCountAndWeekDay(
            selectedMensa: $navigationManager.selectedMensa,
            selectedWeekdayCode: $navigationManager.selectedWeekdayCode
        )
        .refreshable {
            Task {
                await mensaDataManager.reloadUnfilteredMensaList()
            }
        }
        .toolbar {
            DetailViewToolbar(selectedMensa: navigationManager.selectedMensa)
        }
    }
}

#Preview("Sample Data") {
    DetailView()
        .environmentObject(NavigationManager.example)
        .environmentObject(MensaDataManager.shared)
}

#Preview("Live Data") {
    AppView()
        .environmentObject(NavigationManager.shared)
        .environmentObject(MensaDataManager.shared)
}
