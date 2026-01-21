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
                icon: .init(systemName: "person.text.rectangle.fill")!,
                title: .init(localized: "ONBOARDING_FEATURE_2_TITLE"),
                description: .init(localized: "ONBOARDING_FEATURE_2_DESCRIPTION")
            )
        ]
    }
}
