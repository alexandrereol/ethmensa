//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct SettingsAppearanceView: View {

    @EnvironmentObject var settingsManager: SettingsManager

    var priceTypes: [(name: String, type: PriceType)] = [
        (.init(localized: "ALL"), .all),
        (.init(localized: "STUDENT"), .student),
        (.init(localized: "STAFF"), .staff),
        (.init(localized: "EXTERNAL"), .external)
    ]

    var body: some View {
        List {
            Picker("PRICE_TO_SHOW", selection: $settingsManager.priceType) {
                ForEach(priceTypes, id: \.1) { priceType in
                    Text(priceType.name)
                        .tag(priceType.type)
                }
            }
            .pickerStyle(.inline)
        }
    }
}

#Preview {
    SettingsAppearanceView()
        .environmentObject(SettingsManager.shared)
}
