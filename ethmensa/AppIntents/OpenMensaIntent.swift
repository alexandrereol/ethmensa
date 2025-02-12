//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import AppIntents

struct OpenMensaIntent: OpenIntent {
    static let title: LocalizedStringResource = "OPEN_SELECTED_MENSA"

    @Parameter(title: "MENSA")
    var target: MensaEntity

    @Dependency var mensaDataManager: MensaDataManager
    @Dependency var navigationManager: NavigationManager

    @MainActor
    func perform() async throws -> some IntentResult {
        await mensaDataManager.resetFiltersAndSearch()
        navigationManager.sheet = .none
        navigationManager.universalLinkMensaId = target.id
        return .result()
    }
}
