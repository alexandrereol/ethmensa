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

struct ShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: CurrentlyOpenIntent(),
            phrases: [
                "SHOW_OPEN_IN_\(.applicationName)",
                "SHOW_OPEN_MENSAS_IN_\(.applicationName)"
            ],
            shortTitle: "CURRENTLY_OPEN",
            systemImageName: "door.left.hand.open"
        )
        AppShortcut(
            intent: ZentrumIntent(),
            phrases: [
                "SHOWS_ZENTRUM_IN_\(.applicationName)",
                "SHOWS_ZENTRUM_MENSAS_IN_\(.applicationName)"
            ],
            shortTitle: "ZENTRUM_MENSAS",
            systemImageName: "building.2"
        )
        AppShortcut(
            intent: HonggIntent(),
            phrases: [
                "SHOWS_HONGG_IN_\(.applicationName)",
                "SHOWS_HONGG_MENSAS_IN_\(.applicationName)"
            ],
            shortTitle: "HONGG_MENSAS",
            systemImageName: "atom"
        )
        AppShortcut(
            intent: IrchelIntent(),
            phrases: [
                "SHOWS_IRCHEL_IN_\(.applicationName)",
                "SHOWS_IRCHEL_MENSAS_IN_\(.applicationName)"
            ],
            shortTitle: "IRCHEL_MENSAS",
            systemImageName: "graduationcap"
        )
    }
}
