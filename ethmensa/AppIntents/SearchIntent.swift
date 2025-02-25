//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import AppIntents
import Foundation

@available(iOS 17.2, *)
@AssistantIntent(schema: .system.search)
struct SearchIntent: AppIntent {

    static let title: LocalizedStringResource = "SEARCH_IN_ETH_MENSA"
    static let searchScopes: [StringSearchScope] = [.general]

    @Parameter(title: "SEARCH_MENSAS")
    var criteria: StringSearchCriteria

    @Dependency var mensaDataManager: MensaDataManager
    @Dependency var navigationManager: NavigationManager

    @MainActor
    func perform() async throws -> some IntentResult {
        navigationManager.selectedMensa = nil
        await mensaDataManager.resetFiltersAndSearch()
        mensaDataManager.searchTerm = criteria.term
        navigationManager.sheet = .none
        return .result()
    }
}
