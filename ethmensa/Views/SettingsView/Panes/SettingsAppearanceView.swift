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

struct SettingsAppearanceView: View {

    @EnvironmentObject var settingsManager: SettingsManager

    private var priceTypes: [(name: String, priceType: PriceType)] = [
        (.init(localized: "ALL"), PriceType.all),
        (.init(localized: "STUDENT"), PriceType.student),
        (.init(localized: "STAFF"), PriceType.staff),
        (.init(localized: "EXTERNAL"), PriceType.external)
    ]

    var body: some View {
        Section {
            Toggle(
                "HIDE_MENSAS_WITHOUT_MENUS",
                systemImage: "tag.slash.fill",
                isOn: $settingsManager.hideMensaWithNoMenus
            )
#if os(watchOS)
            .tint(.blue)
#else
            .tint(.accent)
#endif
            Picker(
                "PRICE_TO_SHOW",
                systemImage: "dollarsign.circle.fill",
                selection: $settingsManager.priceType
            ) {
                ForEach(priceTypes, id: \.priceType) { priceType in
                    Text(priceType.name)
                        .tag(priceType.priceType)
                        .foregroundStyle(.accent)
                }
            }
        } header: {
            Text("APPEARANCE")
        } footer: {
            Text("PRICE_TO_SHOW_FOOTER")
        }
    }
}

#Preview {
    List {
        SettingsAppearanceView()
            .environmentObject(SettingsManager.shared)
    }
}
