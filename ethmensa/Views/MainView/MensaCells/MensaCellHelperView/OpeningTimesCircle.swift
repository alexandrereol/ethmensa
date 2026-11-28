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

    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor

    var mensa: Mensa
    var isLoading: Bool

    var body: some View {
        // Computed once per render, so the color, symbol and label always agree.
        let status = mensa.getOpeningTimes()
        let statusLabel: LocalizedStringKey = status == .open ? "MENSA_STATUS_OPEN" : "MENSA_STATUS_CLOSED"
        if status != .unknown {
            Group {
                if differentiateWithoutColor && !isLoading {
                    // A check or cross tells open and closed apart without color.
                    Image(systemName: status == .open ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                } else {
                    Circle()
                }
            }
            .foregroundStyle(isLoading ? Color.gray : status == .open ? Color.green : Color.red)
            .frame(
                width: 15,
                height: 15
            )
            .accessibilityElement()
            .accessibilityLabel(statusLabel)
            .accessibilityHidden(isLoading)
        }
    }
}

#Preview {
    OpeningTimesCircle(mensa: .example, isLoading: false)
    OpeningTimesCircle(mensa: .example, isLoading: true)
}
