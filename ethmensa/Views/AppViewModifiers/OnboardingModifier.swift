//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
