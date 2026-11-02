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

private struct ClickCountAndWeekdayModifier: ViewModifier {

    @EnvironmentObject var navigationManager: NavigationManager

    @Binding var selectedMensa: Mensa?
    @Binding var selectedWeekdayCode: Int

    func body(content: Content) -> some View {
        content
            .onAppear {
                guard let selectedMensa else {
                    return
                }
                onAppear(selectedMensa)
            }
            .onChange(of: selectedMensa) { value in
                guard let value else {
                    return
                }
                onAppear(value)
            }
    }

    private func onAppear(_ mensa: Mensa) {
        mensa.increaseClicks()
#if !os(watchOS)
        // A restored or newly opened window shows the weekday it was showing, or was opened for.
        if let restoredWeekdayCode = navigationManager.restoredWeekdayCode {
            navigationManager.restoredWeekdayCode = nil
            selectedWeekdayCode = restoredWeekdayCode
            return
        }
#endif
        if navigationManager.selectedWeekdayCodeOverride == nil {
            selectedWeekdayCode = Calendar.todayWeedaykETHCorrected
        }
    }
}

extension View {
    func clickCountAndWeekDay(
        selectedMensa: Binding<Mensa?>,
        selectedWeekdayCode: Binding<Int>
    ) -> some View {
        self.modifier(
            ClickCountAndWeekdayModifier(
                selectedMensa: selectedMensa,
                selectedWeekdayCode: selectedWeekdayCode
            )
        )
    }
}
