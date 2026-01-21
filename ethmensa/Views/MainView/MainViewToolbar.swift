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

struct MainViewToolbar: ToolbarContent {

    @Binding var mensaCellType: MensaCellType

    private var cellTypes: [(name: String, type: MensaCellType)] {
        var result: [(String, MensaCellType)] = [
            (.init(localized: "MINIMAL_VIEW"), .minimal),
            (.init(localized: "STANDARD_VIEW"), .standard)
        ]
        if UIDevice.current.userInterfaceIdiom == .phone {
            result.append(
                (String(localized: "LARGE_VIEW"), .large)
            )
        }
        return result
    }

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                Picker("MENSA_CELL_SIZE", selection: $mensaCellType) {
                    ForEach(cellTypes, id: \.type) { viewType in
                        Text(viewType.name)
                            .tag(viewType.type)
                    }
                }
            } label: {
                Image(systemName: "square.text.square")
            }
        }
#if !os(watchOS) && !os(visionOS) && !APPCLIP && !targetEnvironment(macCatalyst)
        ToolbarItem(placement: .topBarTrailing) {
            Button("LEGI_CARD", systemImage: "person.text.rectangle") {
                NavigationManager.shared.sheet = .legiCard
            }
        }
#endif
#if !APPCLIP
        ToolbarItem(placement: .topBarTrailing) {
            Button("SETTINGS", systemImage: "gear") {
                NavigationManager.shared.sheet = .settings
            }
        }
#endif
    }
}

#Preview {
    AppView()
        .environmentObject(NavigationManager.shared)
        .environmentObject(MensaDataManager.shared)
        .environmentObject(NetworkManager.shared)
        .environmentObject(SettingsManager.shared)
}
