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

/// Presents the welcome screen as a full-screen cover on the first launch.
struct OnboardingModifier: ViewModifier {

    /// Whether onboarding still has to be shown, i.e. the first launch isn't completed yet.
    let isPending: Bool

    /// Called when the user taps Continue, to record the first launch as completed.
    let completionHandler: () -> Void

    // Presented once the view has appeared, not from the first layout, which can drop the cover on a
    // fresh install.
    @State private var isPresented = false

    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                OnboardingWelcomeView(
                    appIcon: Image(.appIconRoundedForUserVersion),
                    displayName: Bundle.main.displayName,
                    accent: .accent,
                    features: .onboarding,
                    privacyMessage: String(localized: "ONBOARDING_PRIVACY_POLICY_MESSAGE"),
                    privacyPolicyURL: String.privacyPolicyURLString.toURL()
                ) {
                    isPresented = false
                    // The demo shows onboarding on every launch, so it doesn't record it as completed.
                    if !OnboardingDemo.isActive {
                        completionHandler()
                    }
                }
            }
            .onAppear {
                if isPending || OnboardingDemo.isActive {
                    isPresented = true
                }
            }
    }
}

extension View {
    func onboardingFullScreenCoverIfNecessary(
        isPending: Bool,
        completionHandler: @escaping () -> Void
    ) -> some View {
        self.modifier(
            OnboardingModifier(
                isPending: isPending,
                completionHandler: completionHandler
            )
        )
    }
}

/// Shows onboarding for screenshots in Debug builds, whether or not the first launch is completed.
///
/// `DEMO=onboarding` shows onboarding from its first step, `DEMO=onboarding DEMO_ROUTE=onboarding.<step>`
/// at that step. The welcome screen, `onboarding.welcome`, is the only step, so both show it.
///
/// These are the launch arguments of reol-spm's DemoKit, which ETH Mensa doesn't link. Release builds
/// ignore them.
enum OnboardingDemo {

    /// Whether the launch arguments ask for onboarding.
    static let isActive: Bool = {
#if DEBUG
        argument("DEMO")?.lowercased() == "onboarding"
#else
        false
#endif
    }()

#if DEBUG
    /// The value of the last `<name>=<value>` launch argument, trimmed.
    private static func argument(_ name: String) -> String? {
        ProcessInfo.processInfo.arguments
            .last { $0.hasPrefix(name + "=") }
            .map { $0.dropFirst(name.count + 1).trimmingCharacters(in: .whitespaces) }
    }
#endif
}
#endif
