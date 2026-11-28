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

    private var status: Mensa.OpeningTimeState {
        mensa.getOpeningTimes()
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
    /// The status spoken by VoiceOver, e.g. "Closed". `nil` while loading.
    private var statusLabel: String? {
        guard !isLoading else {
            return nil
        }
        switch status {
        case .open: return .init(localized: "MENSA_STATUS_OPEN")
        case .closed: return .init(localized: "MENSA_STATUS_CLOSED")
        case .unknown: return nil
        }
    }
    /// With Differentiate Without Color on, a check or cross tells open and closed apart.
    private var differentiatingSymbol: String? {
        guard differentiateWithoutColor, !isLoading else {
            return nil
        }
        switch status {
        case .open: return "checkmark.circle.fill"
        case .closed: return "xmark.circle.fill"
        case .unknown: return nil
        }
    }

    var body: some View {
        if status != .unknown {
            Group {
                if let differentiatingSymbol {
                    Image(systemName: differentiatingSymbol)
                        .resizable()
                        .scaledToFit()
                } else {
                    Circle()
                }
            }
            .foregroundStyle(circleColor)
            .frame(
                width: 15,
                height: 15
            )
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(statusLabel ?? "")
            .accessibilityHidden(statusLabel == nil)
        }
    }
}

#Preview {
    OpeningTimesCircle(mensa: .example, isLoading: false)
    OpeningTimesCircle(mensa: .example, isLoading: true)
}
