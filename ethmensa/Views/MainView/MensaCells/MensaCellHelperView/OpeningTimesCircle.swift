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

    private var accessibilityStatusLabel: String {
        switch status {
        case .open: String(localized: "OPEN")
        case .closed: String(localized: "ACCESSIBILITY_CLOSED")
        case .unknown: ""
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
                .accessibilityLabel(accessibilityStatusLabel)
                .accessibilityHidden(isLoading)
        }
    }
}

#Preview {
    OpeningTimesCircle(mensa: .example, isLoading: false)
    OpeningTimesCircle(mensa: .example, isLoading: true)
}
