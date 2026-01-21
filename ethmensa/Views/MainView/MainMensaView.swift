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

struct MainMensaView: View {

    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var mensaDataManager: MensaDataManager

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
            ShareLink(
                item: mensa.shareURL,
                preview: .init(
                    mensa.name,
                    image: Image(uiImage: .appIconRoundedForUserVersion)
                )
            )
        } preview: {
            DetailView(contextMenuPreview: true)
                .environmentObject(NavigationManager(selectedMensa: mensa))
                .environmentObject(mensaDataManager)
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
