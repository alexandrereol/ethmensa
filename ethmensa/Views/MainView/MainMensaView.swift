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

    @Environment(\.supportsMultipleWindows) private var supportsMultipleWindows
    @Environment(\.openWindow) private var openWindow

    var mensa: Mensa
    var isLoading = false

    var body: some View {
        MainMensaCellView(
            mensa: mensa,
            isLoading: isLoading
        )
        // Here a custom uiID is used to ensure SwiftUI updates cell when the opening times changes
        .id(mensa.uiID)
        // Dragged to the edge of the screen, the Mensa opens in a new window.
        .onDrag {
            mensa.dragItemProvider(weekdayCode: navigationManager.selectedWeekdayCodeOverride)
        }
        .contextMenu {
            if supportsMultipleWindows {
                Button(
                    "OPEN_IN_NEW_WINDOW",
                    systemImage: "macwindow.badge.plus"
                ) {
                    openWindow(
                        value: MensaWindow(
                            mensaId: mensa.id,
                            weekdayCode: navigationManager.selectedWeekdayCodeOverride
                        )
                    )
                }
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
                .environmentObject(
                    NavigationManager(
                        selectedMensa: mensa,
                        selectedWeekdayCodeOverride: navigationManager.selectedWeekdayCodeOverride,
                        allergenFriendlyOnly: navigationManager.allergenFriendlyOnly
                    )
                )
                .environmentObject(mensaDataManager)
        }
    }
}

#Preview {
    NavigationStack {
        List {
            MainMensaView(mensa: .example)
                .environmentObject(MensaDataManager.shared)
                .environmentObject(NavigationManager())
                .environmentObject(SettingsManager.shared)
        }
    }
}
