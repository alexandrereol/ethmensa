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

/// A feature the welcome screen lists: an SF Symbol beside its title and description.
///
/// Pass the title and description as `LocalizedStringResource`s to look them up in the app's string
/// catalog when the screen is shown. Spell the type out: bare string literals pick the `String`
/// initializer, so the keys would show as they are.
///
/// ```swift
/// OnboardingFeature(
///     systemImage: "figure.walk",
///     title: LocalizedStringResource("ONBOARDING_FEATURE_1_TITLE"),
///     description: LocalizedStringResource("ONBOARDING_FEATURE_1_DESCRIPTION")
/// )
/// ```
///
/// A `String` value, e.g. `String(localized:)` or text from a server, is shown as it is.
struct OnboardingFeature: Sendable {

    /// The text of a title or description: looked up in a catalog, or shown as it is.
    enum Content: Sendable {
        case resource(LocalizedStringResource)
        case verbatim(String)

        var text: Text {
            switch self {
            case .resource(let resource):
                Text(resource)
            case .verbatim(let string):
                Text(verbatim: string)
            }
        }
    }

    /// The name of the SF Symbol shown beside the text.
    let systemImage: String
    let title: Content
    let description: Content

    /// A feature whose title and description are looked up in a string catalog, the app's by default.
    init(systemImage: String, title: LocalizedStringResource, description: LocalizedStringResource) {
        self.systemImage = systemImage
        self.title = .resource(title)
        self.description = .resource(description)
    }

    /// A feature whose title and description are shown as they are, e.g. already localized strings.
    @_disfavoredOverload
    init(systemImage: String, title: String, description: String) {
        self.systemImage = systemImage
        self.title = .verbatim(title)
        self.description = .verbatim(description)
    }

}
#endif
