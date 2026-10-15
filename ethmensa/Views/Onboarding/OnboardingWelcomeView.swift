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

// Copied from reol-spm's OnboardingKit (Sources/OnboardingKit/Welcome), with OnboardingFeature.swift and
// FoldClearance.swift, as ETH Mensa doesn't link reol-spm. Keep it in sync with the kit: only the strings'
// bundle, the app's own, and the access levels differ.
#if os(iOS)
import SwiftUI

/// The welcome screen of the first launch: the app's icon and name, its features, the privacy notice
/// and Continue.
///
/// At compact width it's one scrolling column, with the privacy notice and Continue pinned to its foot.
/// At regular width on iOS 27.1, an `ArrangementView` puts the icon and the name in one pane and the
/// rest in the other, so neither runs through the fold of a foldable iPhone's inner display. Mac
/// Catalyst keeps the column. It lays out in the space it gets, inside the safe area, in any
/// orientation: no screen size tables, no idiom checks.
///
/// Present it on its own with `onboardingWelcome(state:…)`, or make it the root of an ``OnboardingHost``
/// and push the app's steps from `onContinue`.
struct OnboardingWelcomeView: View {

    /// "The app does not contain any tracking or analytics whatsoever…", for apps where that's true.
    static var noTrackingMessage: String {
        WelcomeStrings.noTrackingMessage
    }

    private static let padding: CGFloat = 30
    private static let maxColumnWidth: CGFloat = 480

    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private let appIcon: Image
    private let displayName: String
    private let accent: Color
    private let features: [OnboardingFeature]
    private let privacyMessage: String
    private let privacyPolicyURL: URL?
    private let continueTitle: LocalizedStringResource?
    private let background: AnyShapeStyle?
    private let onContinue: (() -> Void)?

    /// - Parameters:
    ///   - appIcon: The app's icon, unrounded: the screen rounds its corners.
    ///   - displayName: The app's name, shown in `accent` under "Welcome to".
    ///   - accent: The colour of the name, the link and Continue.
    ///   - features: The features to list, three or four usually.
    ///   - privacyMessage: The privacy notice before the link, e.g. `String(localized: "…")`. Pass
    ///     ``noTrackingMessage`` only if the app really has no tracking or analytics.
    ///   - privacyPolicyURL: Where the notice's link goes; `nil` leaves the link out.
    ///   - continueTitle: The button's title. Defaults to Continue.
    ///   - background: What fills the screen behind the content. Defaults to the grouped background
    ///     colour; pass `AnyShapeStyle(.clear)` to show an ``OnboardingHost``'s background.
    ///   - onContinue: What Continue does. Defaults to dismissing the screen.
    init(
        appIcon: Image,
        displayName: String,
        accent: Color,
        features: [OnboardingFeature],
        privacyMessage: String,
        privacyPolicyURL: URL?,
        continueTitle: LocalizedStringResource? = nil,
        background: AnyShapeStyle? = nil,
        onContinue: (() -> Void)? = nil
    ) {
        self.appIcon = appIcon
        self.displayName = displayName
        self.accent = accent
        self.features = features
        self.privacyMessage = privacyMessage
        self.privacyPolicyURL = privacyPolicyURL
        self.continueTitle = continueTitle
        self.background = background
        self.onContinue = onContinue
    }

    var body: some View {
        content
            // Only the background runs under the status bar and the camera; the content stays in the safe area.
            .background {
                Rectangle()
                    .fill(background ?? AnyShapeStyle(Color(uiColor: .systemGroupedBackground)))
                    .ignoresSafeArea()
            }
            .tint(accent)
            // As the root of a navigation stack: no empty navigation bar above the icon.
            .toolbar(.hidden, for: .navigationBar)
    }

    @ViewBuilder
    private var content: some View {
#if targetEnvironment(macCatalyst)
        // The macOS SDK that Mac Catalyst builds with has no `ArrangementView`.
        column
#else
        // The default split, not `.axes(.horizontal)`: where it can't put the panes side by side, e.g. iPad in
        // portrait, it stacks them instead of showing only one, which could hide Continue. Compact width keeps the
        // column, as the split would stack the panes there, half the height each.
        if #available(iOS 27.1, *), horizontalSizeClass == .regular {
            ArrangementView {
                iconAndTitle
                    .padding(Self.padding)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foldClearance()
            } secondary: {
                // Centred between the top of the pane and the privacy notice while the features fit;
                // scrolling, from the top, once they don't (large text sizes).
                ViewThatFits(in: .vertical) {
                    paneFeatureList
                        .frame(maxHeight: .infinity)
                    ScrollView {
                        paneFeatureList
                    }
                }
                .welcomeBottomBar {
                    noticeAndContinue
                }
                .foldClearance()
            }
        } else {
            column
        }
#endif
    }

    /// The features as the second pane shows them, beside the icon and the name.
    private var paneFeatureList: some View {
        featureList
            .padding(.horizontal, Self.padding)
            .padding(.vertical, 40)
            .frame(maxWidth: Self.maxColumnWidth)
            .frame(maxWidth: .infinity)
    }

    /// The icon, the name and the features in one scrolling column, with the privacy notice and Continue
    /// pinned to its foot.
    private var column: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                iconAndTitle
                featureList
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Self.padding)
            .padding(.vertical, 40)
            .frame(maxWidth: Self.maxColumnWidth)
            .frame(maxWidth: .infinity)
        }
        .welcomeBottomBar {
            noticeAndContinue
        }
    }

    private var iconSize: CGFloat {
        horizontalSizeClass == .regular ? 140 : 78
    }

    private var iconAndTitle: some View {
        VStack(alignment: .leading, spacing: 26) {
            appIcon
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .clipShape(RoundedRectangle(cornerRadius: iconSize * 0.2237, style: .continuous))
                .accessibilityHidden(true)
            // One text, so both lines shrink to the same size when the welcome line or the name is long.
            Text(title)
                .font(.system(size: horizontalSizeClass == .regular ? 80 : 44, weight: .heavy))
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .accessibilityAddTraits(.isHeader)
        }
    }

    private var title: AttributedString {
        var text = AttributedString(WelcomeStrings.welcomeTo + "\n")
        var name = AttributedString(displayName)
        name.foregroundColor = accent
        text.append(name)
        return text
    }

    private var featureList: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(features.indices, id: \.self) { index in
                let feature = features[index]
                HStack(alignment: .top, spacing: 18) {
                    Image(systemName: feature.systemImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 2) {
                        feature.title.text
                            .font(.headline)
                        feature.description.text
                            .font(.body.weight(.light))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .accessibilityElement(children: .combine)
            }
        }
    }

    private var noticeAndContinue: some View {
        VStack(spacing: 20) {
            Text(privacyNotice)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
                if let onContinue {
                    onContinue()
                } else {
                    dismiss()
                }
            } label: {
                Group {
                    if let continueTitle {
                        Text(continueTitle)
                    } else {
                        Text(verbatim: WelcomeStrings.continue)
                    }
                }
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 45)
            }
            // The same button as the onboarding steps' main one (`OnboardingPrimaryButton`), kept in
            // this file so the welcome screen can be copied on its own.
            .welcomePrimaryButtonStyle()
        }
        // Pinned, so it can't grow over the whole screen.
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
        .padding(.horizontal, Self.padding)
        .padding(.vertical, 20)
        .frame(maxWidth: Self.maxColumnWidth)
        .frame(maxWidth: .infinity)
    }

    private var privacyNotice: AttributedString {
        var notice = AttributedString(privacyMessage)
        guard let privacyPolicyURL else {
            return notice
        }
        notice.append(AttributedString(" "))
        var link = AttributedString(WelcomeStrings.privacyPolicy)
        link.link = privacyPolicyURL
        notice.append(link)
        return notice
    }

}

private extension View {

    /// Prominent glass on iOS 26 and later, a bordered prominent capsule before: the same style as
    /// `onboardingPrimaryButtonStyle()`.
    @ViewBuilder
    func welcomePrimaryButtonStyle() -> some View {
        if #available(iOS 26.0, *) {
            buttonStyle(.glassProminent)
        } else {
            buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
        }
    }

}

/// The welcome screen's own strings, in the language the app runs in.
private enum WelcomeStrings {

    /// The strings' bundle: the app's own, whose catalog has the four keys below.
    static let bundle: Bundle = .main

    static var welcomeTo: String { string("WELCOME_TO") }
    static var `continue`: String { string("CONTINUE") }
    static var privacyPolicy: String { string("PRIVACY_POLICY") }
    static var noTrackingMessage: String { string("ONBOARDING_PRIVACY_POLICY_MESSAGE") }

    private static func string(_ key: String) -> String {
        bundle.localizedString(forKey: key, value: nil, table: nil)
    }

}

private extension View {

    /// Pins `content` under a scroll view, with the scroll view's content passing under it.
    @ViewBuilder
    func welcomeBottomBar(@ViewBuilder _ content: () -> some View) -> some View {
        if #available(iOS 26.0, *) {
            // The scroll edge effect fades out the content that passes under the bar.
            safeAreaBar(edge: .bottom) {
                content()
            }
        } else {
            safeAreaInset(edge: .bottom, spacing: 0) {
                content()
                    .background(.bar)
            }
        }
    }

}

#Preview {
    OnboardingWelcomeView(
        appIcon: Image(systemName: "app.fill"),
        displayName: String("Demo"),
        accent: .orange,
        features: [
            OnboardingFeature(
                systemImage: "sparkles",
                title: String("Feature"),
                description: String("This is a cool and new feature!")
            ),
            OnboardingFeature(
                systemImage: "lock.shield",
                title: String("Private"),
                description: String("Everything stays on your device.")
            )
        ],
        privacyMessage: OnboardingWelcomeView.noTrackingMessage,
        privacyPolicyURL: URL(string: "https://reol.ch")
    )
}
#endif
