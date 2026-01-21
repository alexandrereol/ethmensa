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
import UIOnboarding

struct OnboardingModifier: ViewModifier {

    @Binding var showOnboarding: Bool

    var completionHandler: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $showOnboarding) {
                OnboardingView(
                    completionHandler: completionHandler
                )
                .edgesIgnoringSafeArea(.all)
            }
    }
}

extension View {
    func onboardingFullScreenCoverIfNecessary(
        showOnboarding: Binding<Bool>,
        completionHandler: (() -> Void)?
    ) -> some View {
        self.modifier(
            OnboardingModifier(
                showOnboarding: showOnboarding,
                completionHandler: completionHandler
            )
        )
    }
}
