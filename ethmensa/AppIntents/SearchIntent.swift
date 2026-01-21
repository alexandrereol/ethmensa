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
