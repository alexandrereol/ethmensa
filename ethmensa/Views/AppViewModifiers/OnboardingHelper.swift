//
//   Copyright © 2025 Alexandre Reol. All rights reserved.
//

import UIKit
import UIOnboarding

struct OnboardingFeature {
    let image: UIImage?
    let title: String
    let description: String
}

private struct OnboardingHelper {
    static var firstTitleLine: NSMutableAttributedString {
        .init(
            string: .init(localized: "WELCOME_TO"),
            attributes: [.foregroundColor: UIColor.label]
        )
    }

    static func secondTitleLine(
        displayName: String,
        accent: UIColor
    ) -> NSMutableAttributedString {
        .init(
            string: displayName,
            attributes: [.foregroundColor: accent]
        )
    }

    static func notice(
        privacyPolicyURLString: String,
        accent: UIColor
    ) -> UIOnboardingTextViewConfiguration {
        .init(
            text: .init(localized: "ONBOARDING_PRIVACY_POLICY_MESSAGE"),
            linkTitle: .init(localized: "PRIVACY_POLICY"),
            link: privacyPolicyURLString,
            tint: accent
        )
    }

    static func button(
        accent: UIColor
    ) -> UIOnboardingButtonConfiguration {
        .init(
            title: .init(localized: "CONTINUE"),
            backgroundColor: accent
        )
    }
}

extension UIOnboardingViewConfiguration {
    static func get(
        appIcon: UIImage,
        displayName: String,
        accent: UIColor,
        onboardingFeatures: [UIOnboardingFeature],
        privacyPolicyURLString: String
    ) -> UIOnboardingViewConfiguration {
        .init(
            appIcon: appIcon,
            firstTitleLine: OnboardingHelper.firstTitleLine,
            secondTitleLine: OnboardingHelper
                .secondTitleLine(
                    displayName: displayName,
                    accent: accent
                ),
            features: onboardingFeatures,
            textViewConfiguration: OnboardingHelper
                .notice(
                    privacyPolicyURLString: privacyPolicyURLString,
                    accent: accent
                ),
            buttonConfiguration: OnboardingHelper
                .button(
                    accent: accent
                )
        )
    }
}
