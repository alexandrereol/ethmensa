//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct MainMensaView: View {

    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var mensaDataManager: MensaDataManager

    @State var shareSheetShown = false

    var mensa: Mensa
    var isLoading = false

    var body: some View {
        MainMensaCellView(
            mensa: mensa,
            isLoading: isLoading
        )
        // Here a custom uiID is used to ensure SwiftUI updates cell when the opening times changes
        .id(mensa.uiID)
        .draggable(mensa)
        .contextMenu {
            Button(
                "OPEN",
                systemImage: "arrow.up.right.square"
            ) {
                navigationManager.selectedMensa = mensa
            }
            Button(
                "SHARE",
                systemImage: "square.and.arrow.up"
            ) {
                shareSheetShown = true
            }
        } preview: {
            DetailView(contextMenuPreview: true)
                .environmentObject(NavigationManager(selectedMensa: mensa))
                .environmentObject(mensaDataManager)
        }
        .sheet(isPresented: $shareSheetShown) {
            UIActivityView(
                name: mensa.name,
                url: mensa.shareURL,
                image: .appIconRounded,
                excludedActivityTypes: []
            )
            .presentationDetents(
                [.medium]
            )
        }
    }
}

#Preview {
    NavigationStack {
        List {
            MainMensaView(mensa: .example)
                .environmentObject(MensaDataManager.shared)
                .environmentObject(NavigationManager.shared)
                .environmentObject(SettingsManager.shared)
        }
    }
}
