//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
