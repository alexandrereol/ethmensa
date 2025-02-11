//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct WeekdaySelectorHeaderView: View {

    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        if navigationManager.selectedWeekdayCodeOverride == nil {
            Picker("WEEKDAY", selection: $navigationManager.selectedWeekdayCode.animation()) {
                ForEach(Date.weekdaysStartingAtOne, id: \.index) { mealtime in
                    Text(mealtime.string)
                        .tag(mealtime.index)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

#Preview {
    List {
        WeekdaySelectorHeaderView()
    }
    .environmentObject(NavigationManager.example)
}
