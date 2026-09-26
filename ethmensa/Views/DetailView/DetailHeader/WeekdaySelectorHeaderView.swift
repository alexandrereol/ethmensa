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

struct WeekdaySelectorHeaderView: View {

    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        Picker("WEEKDAY", selection: $navigationManager.selectedWeekdayCode.animation()) {
            ForEach(Date.weekdaysStartingAtOne, id: \.index) { mealtime in
                Text(mealtime.string)
                    .tag(mealtime.index)
            }
        }
        .pickerStyle(.menu)
        // While a day is selected in the filter menu, the menu of that day is shown.
        .disabled(navigationManager.selectedWeekdayCodeOverride != nil)
        if navigationManager.allergenFriendlyOnly {
            Label("ALLERGEN_FRIENDLY", systemImage: MensaFilter.allergenFriendly.systemImageName)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    List {
        WeekdaySelectorHeaderView()
    }
    .environmentObject(NavigationManager.example)
}
