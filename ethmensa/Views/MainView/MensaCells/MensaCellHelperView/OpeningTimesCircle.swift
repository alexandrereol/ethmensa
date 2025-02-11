//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct OpeningTimesCircle: View {

    var mensa: Mensa
    var isLoading: Bool

    private var status: Mensa.OpeningTimeState {
        SettingsManager.shared.screenshotMode ? .open : mensa.getOpeningTimes()
    }
    private var circleColor: Color {
        if isLoading {
            .gray
        } else {
            switch status {
            case .open: .green
            case .closed: .red
            case .unknown: .clear
            }
        }
    }

    var body: some View {
        if status != .unknown {
            Circle()
                .foregroundStyle(circleColor)
                .frame(
                    width: 15,
                    height: 15
                )
        }
    }
}

#Preview {
    OpeningTimesCircle(mensa: .example, isLoading: false)
    OpeningTimesCircle(mensa: .example, isLoading: true)
}
