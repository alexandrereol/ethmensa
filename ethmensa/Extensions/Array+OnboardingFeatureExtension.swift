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

#if os(iOS)
import SwiftUI

extension [OnboardingFeature] {
    /// The features the welcome screen lists, looked up in the app's string catalog when it shows.
    ///
    /// The keys are spelled as `LocalizedStringResource`s: as bare string literals, Swift picks the
    /// `String` initializer and the keys show as they are.
    static let onboarding: Self = [
        OnboardingFeature(
            systemImage: "carrot.fill",
            title: LocalizedStringResource("ONBOARDING_FEATURE_1_TITLE"),
            description: LocalizedStringResource("ONBOARDING_FEATURE_1_DESCRIPTION")
        ),
        OnboardingFeature(
            systemImage: "person.text.rectangle.fill",
            title: LocalizedStringResource("ONBOARDING_FEATURE_2_TITLE"),
            description: LocalizedStringResource("ONBOARDING_FEATURE_2_DESCRIPTION")
        )
    ]
}
#endif
