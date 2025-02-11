//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
