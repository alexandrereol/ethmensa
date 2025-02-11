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
