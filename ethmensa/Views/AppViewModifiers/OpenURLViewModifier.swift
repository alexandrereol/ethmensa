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

import RegexBuilder
import SwiftUI

private struct OpenURLViewModifier: ViewModifier {

#if !APPCLIP
    @EnvironmentObject var navigationManager: NavigationManager
#endif

    @Binding var universalLinkAlertShown: Bool
    @Binding var universalLinkMensaId: String?

    func body(content: Content) -> some View {
        content
            .onOpenURL { url in
                let mensaIdRef = Reference<Substring>()
                let regex = Regex {
                    "/s/"
                    Capture(as: mensaIdRef) {
                        OneOrMore(.word)
                        "/"
                        OneOrMore(.digit)
                    }
                    Optionally("/")
                }
                if let matchSubstring = url.relativePath.firstMatch(of: regex)?[mensaIdRef] {
                    universalLinkMensaId = String(matchSubstring)
                }
            }
#if !APPCLIP
            // Opens the Mensa continued from another device with Handoff, closing any sheet in front of it.
            .onContinueUserActivity(Mensa.handoffActivityType) { activity in
                guard let mensaId = activity.userInfo?[Mensa.handoffMensaIdKey] as? String else {
                    return
                }
                navigationManager.sheet = .none
                universalLinkMensaId = mensaId
            }
#endif
            .alert(
                "UNIVERSAL_LINK_NO_MENSA",
                isPresented: $universalLinkAlertShown
            ) {
                if #available(iOS 26.0, visionOS 26.0, *) {
                    Button(role: .close) {
                        universalLinkAlertShown = false
                    }
                } else {
                    Button("CLOSE") {
                        universalLinkAlertShown = false
                    }
                }
            } message: {
                Text("UNIVERSAL_LINK_NO_MENSA_MESSAGE")
            }
    }
}

extension View {
    func openURL(
        universalLinkAlertShown: Binding<Bool>,
        universalLinkMensaId: Binding<String?>
    ) -> some View {
        self.modifier(
            OpenURLViewModifier(
                universalLinkAlertShown: universalLinkAlertShown,
                universalLinkMensaId: universalLinkMensaId
            )
        )
    }
}
