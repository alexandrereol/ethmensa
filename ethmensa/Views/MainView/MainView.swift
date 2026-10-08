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

    private func viewState(for mensaList: [Mensa]?) -> ViewState {
        if let mensaList {
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
        // The filtered list is derived on access, so it is computed only once per render.
        let mensaList = mensaDataManager.mensaList
        let viewState = self.viewState(for: mensaList)
        ZStack {
            List(selection: $navigationManager.selectedMensa) {
                Section {
                    if viewState == .loadedWithContent {
                        ForEach(mensaList ?? []) { mensa in
                            MainMensaView(mensa: mensa)
                        }
                    } else if viewState == .loading {
                        ForEach(Array(repeating: Mensa.example, count: 10)) { mensa in
                            MainMensaView(mensa: mensa, isLoading: true)
                        }
                        .onAppear {
                            // The list may also be loading while the campuses of the mensas are determined.
                            guard mensaDataManager.unfilteredMenaList == nil else {
                                return
                            }
                            Task {
                                await mensaDataManager.reloadUnfilteredMensaList()
                            }
                        }
                    }
                } header: {
                    // A header instead of a row, as inserting or removing a row makes the list jump
                    // and an empty row would leave a gap.
                    FilterView()
                        .textCase(nil)
                        // Section headers are inset like the cells' content and ignore `listRowInsets`,
                        // so the chips are pulled out to align with the edges of the cells.
                        .padding(.horizontal, -16)
                        // Brings the chips a little closer to the title.
                        .padding(.top, -6)
                        // Gives the chips a little room above the first cell, without leaving a gap without filters.
                        .padding(.bottom, MensaFilter.isAnyActive ? 6 : 0)
                }
            }
            .environment(\.defaultMinListHeaderHeight, 0)
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
                        .resetButtonStyle()
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
            MainViewToolbar()
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

private extension View {

    /// Styles the reset button of the empty state prominently.
    /// On iOS 26 and later it uses Liquid Glass. The glass styles are not
    /// available on visionOS, whose bordered buttons are already glass.
    @ViewBuilder
    func resetButtonStyle() -> some View {
#if !os(visionOS)
        if #available(iOS 26.0, *) {
            self
                .buttonStyle(.glassProminent)
        } else {
            legacyResetButtonStyle()
        }
#else
        legacyResetButtonStyle()
#endif
    }

    private func legacyResetButtonStyle() -> some View {
        self
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
    }
}
