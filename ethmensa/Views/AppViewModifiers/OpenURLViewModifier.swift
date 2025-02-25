//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import RegexBuilder
import SwiftUI

private struct OpenURLViewModifier: ViewModifier {

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
            .alert(
                "UNIVERSAL_LINK_NO_MENSA",
                isPresented: $universalLinkAlertShown
            ) {
                Button("CLOSE", role: .cancel) { }
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
