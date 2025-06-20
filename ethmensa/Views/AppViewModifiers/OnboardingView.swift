//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI
import UIOnboarding

struct OnboardingView: UIViewControllerRepresentable {

    var completionHandler: (() -> Void)?

    func makeUIViewController(
        context: Context
    ) -> UIOnboardingViewController {
        let onboardingController = UIOnboardingViewController(
            withConfiguration: .get(
                appIcon: .appIconRoundedForUserVersion,
                displayName: Bundle.main.displayName,
                accent: .accent,
                onboardingFeatures: .featureTuple,
                privacyPolicyURLString: .privacyPolicyURLString
            )
        )
        onboardingController.delegate = context.coordinator
        return onboardingController
    }

    func updateUIViewController(
        _ uiViewController: UIOnboardingViewController,
        context: Context
    ) { }

    class Coordinator: NSObject, UIOnboardingViewControllerDelegate {

        var completionHandler: (() -> Void)?

        init(completionHandler: (() -> Void)?) {
            self.completionHandler = completionHandler
        }

        func didFinishOnboarding(
            onboardingViewController: UIOnboardingViewController
        ) {
            onboardingViewController.dismiss(animated: true) {
                self.completionHandler?()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        .init(completionHandler: completionHandler)
    }
}

#Preview {
    OnboardingView(completionHandler: nil)
}
