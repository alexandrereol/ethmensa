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

struct DetailView: View {

    @EnvironmentObject var navigationManager: NavigationManager

    var meals: [Meal] {
        navigationManager.selectedMensa?.mealTimes.filter { mealTime in
            mealTime.weekdayCode == navigationManager.selectedWeekdayCode
        }.first?.meals ?? []
    }

    var body: some View {
        if let selectedMensa = navigationManager.selectedMensa {
            Group {
                TabView {
                    ForEach(meals) { meal in
                        DetailMenuView(meal: meal)
                    }

                }
                .tabViewStyle(.verticalPage)
                .onAppear {
                    selectedMensa.increaseClicks()
                }
            }
            .navigationTitle {
                Text(selectedMensa.name)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView()
            .environmentObject(NavigationManager.example)
    }
}
