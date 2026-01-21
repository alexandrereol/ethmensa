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
        case noContent
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

    var body: some View {
        NavigationSplitView {
            Group {
                if viewState == .loadedButEmpty {
                    NoResultsView()
                } else if viewState == .noContent {
                    AllMensasClosedTodayView()
                } else {
                    List(selection: $navigationManager.selectedMensa) {
                        if viewState == .loadedWithContent {
                            ForEach(mensaDataManager.mensaList ?? []) { mensa in
                                MainViewCell(mensa: mensa)
                            }
                        } else if viewState == .loading {
                            ForEach(Array(repeating: Mensa.example, count: 3)) { mensa in
                                MainViewCell(mensa: mensa)
                            }
                            .onAppear {
                                Task {
                                    await mensaDataManager.reloadUnfilteredMensaList()
                                }
                            }
                        }
                    }
                    .listStyle(.carousel)
                    .redacted(reason: viewState == .loading ? .placeholder : [])
                }
            }
            .containerBackground(.blue.gradient, for: .navigation)
            .navigationTitle {
                Text(Bundle.main.displayName)
                    .foregroundColor(.white)
            }
            .toolbar {
                MainViewToolbar(
                    isFiltered: mensaDataManager.isFiltered
                )
            }
        } detail: {
            DetailView()
        }
        .environmentObject(mensaDataManager)
        .environmentObject(navigationManager)
        .sheet(item: $navigationManager.sheet) { type in
            AppViewSheets(type: type)
                .environmentObject(mensaDataManager)
                .environmentObject(navigationManager)
                .environmentObject(settingsManager)
        }
    }
}

#Preview {
    NavigationStack {
        MainView()
            .environmentObject(MensaDataManager.shared)
            .environmentObject(NavigationManager.example)
            .environmentObject(SettingsManager.shared)
    }
}
