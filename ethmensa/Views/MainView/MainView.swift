//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct MainView: View {

    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var mensaDataManager: MensaDataManager
    @EnvironmentObject var settingsManager: SettingsManager

    private enum ViewState {
        case loading
        case loadedButEmpty
        case loadedWithContent
    }

    private var viewState: ViewState {
        if let mensaList = mensaDataManager.mensaList {
            if mensaList.isEmpty {
                .loadedButEmpty
            } else {
                .loadedWithContent
            }
        } else {
            .loading
        }
    }

    private var listRowSpacing: CGFloat {
        let cond1 = settingsManager.mensaCellType == .minimal
        let cond2 = UIDevice.current.userInterfaceIdiom == .pad
        return cond1 && cond2 ? 0 : 15
    }

    var body: some View {
        ZStack {
            List(selection: $navigationManager.selectedMensa) {
                if (mensaDataManager.isFiltered) {
                    FilterView()
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
                if viewState == .loadedWithContent {
                    ForEach(mensaDataManager.mensaList ?? []) { mensa in
                        MainMensaView(mensa: mensa)
                    }
                } else if viewState == .loading {
                    ForEach(Array(repeating: Mensa.example, count: 10)) { mensa in
                        MainMensaView(mensa: mensa, isLoading: true)
                    }
                    .onAppear {
                        Task {
                            await mensaDataManager.reloadUnfilteredMensaList()
                        }
                    }
                }
            }
            .redacted(reason: viewState == .loading ? .placeholder : [])
            .disabled(viewState == .loading)
            .scrollDisabled(viewState == .loading)
            .listRowSpacing(listRowSpacing)
            .refreshable {
                Task {
                    await mensaDataManager.reloadUnfilteredMensaList()
                }
            }
            if viewState == .loadedButEmpty {
                CustomContentUnavailableView(
                    label: .init(localized: "NO_RESULTS"),
                    systemImageName: "sparkle.magnifyingglass",
                    description: .init(localized: "NO_RESULTS_FOR_SELECTED_FILTERS."),
                    actions: {
                        Button {
                            Task {
                                await mensaDataManager.resetFiltersAndSearch()
                            }
                        } label: {
                            Text("RESET_FILTERS_AND_SEARCH")
                                .padding(2)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle)
                    }
                )
            }
        }
        .environmentObject(navigationManager)
        .environmentObject(mensaDataManager)
#if !os(visionOS)
        .navigationTitle(Bundle.main.displayName)
#endif
        .searchable(
            text: $mensaDataManager.searchTerm,
            prompt: "SEARCH_MENSAS"
        )
        .toolbar {
            MainViewToolbar(
                filterOpenOnly: $settingsManager.filterOpenOnly,
                sortAlphabetically: $settingsManager.sortAlphabetically,
                filterCampus: $settingsManager.filterCampus,
                mensaCellType: $settingsManager.mensaCellType,
                isFiltered: mensaDataManager.isFiltered
            )
        }
    }
}

#Preview("Sample Data") {
    NavigationStack {
        MainView()
            .environmentObject(NavigationManager.example)
            .environmentObject(MensaDataManager.shared)
            .environmentObject(SettingsManager.shared)
    }
}

#Preview("Live Data") {
    AppView()
        .environmentObject(NavigationManager.shared)
        .environmentObject(MensaDataManager.shared)
        .environmentObject(NetworkManager.shared)
        .environmentObject(SettingsManager.shared)
}
