//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
