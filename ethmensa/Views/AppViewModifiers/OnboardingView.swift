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
