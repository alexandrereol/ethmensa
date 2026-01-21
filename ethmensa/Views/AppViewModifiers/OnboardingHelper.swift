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
            linkColor: accent
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
