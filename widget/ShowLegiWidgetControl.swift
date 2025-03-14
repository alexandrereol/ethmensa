//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import AppIntents
import SwiftUI
import WidgetKit

struct ShowLegiWidgetControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "ch.alexandrereol.ethmensa.widget.showlegi"
        ) {
            ControlWidgetButton(action: ShowLegiIntent()) {
                Label(
                    "SHOW_LEGI_CARD",
                    systemImage: "person.text.rectangle.fill"
                )
            }
        }
        .displayName("SHOW_LEGI_CARD")
        .description("SHOW_LEGI_CARD_DESCRIPTION")
    }
}
