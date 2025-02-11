//
//   Copyright © 2025 Alexandre Reol. All rights reserved.
//

import UIOnboarding

extension Array<UIOnboardingFeature> {
    /// A static computed property that returns an array of features for the onboarding process.
    /// Each feature is represented as a tuple containing an icon, title, and description.
    /// 
    /// - Returns: An array of features with their respective icons, titles, and descriptions.
    static var featureTuple: Self {
        [
            .init(
                icon: .init(systemName: "carrot.fill")!,
                title: .init(localized: "ONBOARDING_FEATURE_1_TITLE"),
                description: .init(localized: "ONBOARDING_FEATURE_1_DESCRIPTION")
            ),
            .init(
                icon: .init(systemName: "photo")!,
                title: .init(localized: "ONBOARDING_FEATURE_2_TITLE"),
                description: .init(localized: "ONBOARDING_FEATURE_2_DESCRIPTION")
            ),
            .init(
                icon: .init(systemName: "gear")!,
                title: .init(localized: "ONBOARDING_FEATURE_3_TITLE"),
                description: .init(localized: "ONBOARDING_FEATURE_3_DESCRIPTION")
            )
        ]
    }
}
