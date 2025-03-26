//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI
import WhatsNewKit

/// Povider that conforms to the `WhatsNewCollectionProvider` protocol.
struct WhatsNewProvider: WhatsNewCollectionProvider {
    var whatsNewCollection: WhatsNewCollection {
        WhatsNew(
            version: "6.9",
            title: .init(
                stringLiteral: String(localized: "WHATS_NEW_IN_VERSION_\("6.9")")
            ),
            features: [
                .init(
                    image: .init(systemName: "person.text.rectangle.fill"),
                    title: .init(.init(localized: "ACCESS_LEGI_CARD_IN_APP")),
                    subtitle: .init(.init(localized: "LEGI_CARD_SUBTITLE"))
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
                WhatsNewProvider().whatsNewCollection.first!
            )
        )
}
