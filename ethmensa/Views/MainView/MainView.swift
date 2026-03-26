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
                FilterView()
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                if viewState == .loadedWithContent {
                    ForEach(mensaDataManager.mensaList ?? []) { mensa in
                        MainMensaView(mensa: mensa)
                    }
                } else if viewState == .loading {
                    ForEach(Array(repeating: Mensa.example, count: 10)) { mensa in
                        MainMensaView(mensa: mensa, isLoading: true)
                    }
                    .accessibilityHidden(true)
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
                        .accessibilityHint(String(localized: "CLEARS_ALL_ACTIVE_FILTERS_AND_SEARCH_TEXT"))
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
                mensaCellType: $settingsManager.mensaCellType
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
