//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

private struct ClickCountAndWeekdayModifier: ViewModifier {

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
        if NavigationManager.shared.selectedWeekdayCodeOverride == nil {
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
