//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct MainMensaCellView: View {

    @EnvironmentObject var settingsManager: SettingsManager

    var mensa: Mensa
    var isLoading: Bool

    var body: some View {
        switch settingsManager.mensaCellType {
        case .minimal:
            MinimalMensaCellView(
                mensa: mensa,
                isLoading: isLoading
            )
        case .standard:
            StandardMensaCellView(
                mensa: mensa,
                isLoading: isLoading
            )
        case .large:
            LargeMensaCellView(
                mensa: mensa,
                isLoading: isLoading
            )
        }
    }
}
