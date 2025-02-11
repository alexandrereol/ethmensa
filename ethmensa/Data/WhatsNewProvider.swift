//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI
import WhatsNewKit

/// Povider that conforms to the `WhatsNewCollectionProvider` protocol.
struct WhatsNewProvider: WhatsNewCollectionProvider {
    var whatsNewCollection: WhatsNewCollection {
        WhatsNew(
            version: "6.5",
            title: .init(
                stringLiteral: String(localized: "WHATS_NEW_IN_VERSION_\("6.5")")
            ),
            features: [
                .init(
                    image: .init(systemName: "globe.europe.africa"),
                    title: .init(.init(localized: "NEW_LANGUAGES")),
                    subtitle: .init(.init(localized: "NEW_LANGUAGES_SUBTITLE"))
                ),
                .init(
                    image: .init(systemName: "exclamationmark.circle"),
                    title: .init(.init(localized: "BETTER_ALLERGEN_INFO")),
                    subtitle: .init(.init(localized: "BETTER_ALLERGEN_INFO_SUBTITLE"))
                ),
                .init(
                    image: .init(systemName: "line.3.crossed.swirl.circle"),
                    title: .init(.init(localized: "VARIOUS_UI_AND_ANMIATION_IMPROVEMENTS")),
                    subtitle: .init(.init(localized: "VARIOUS_UI_AND_ANMIATION_IMPROVEMENTS_SUBTITLE"))
                )
            ],
            primaryAction: .init(
                title: .init(.init(localized: "CONTINUE")),
                backgroundColor: .accent,
                foregroundColor: .white
            )
        )
    }
}

#Preview {
    Text(String("Hello World!"))
        .sheet(
            whatsNew: .constant(
                WhatsNewProvider().whatsNewCollection.first {
                    $0.version == "6.5"
                }
            )
        )
}
