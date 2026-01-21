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
