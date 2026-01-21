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
