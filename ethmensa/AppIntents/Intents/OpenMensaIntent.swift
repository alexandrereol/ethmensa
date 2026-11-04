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

struct OpenMensaIntent: OpenIntent {
    static let title: LocalizedStringResource = "OPEN_SELECTED_MENSA"

    @Parameter(title: "MENSA")
    var target: MensaEntity

    @MainActor
    func perform() async throws -> some IntentResult {
        let mensaId = target.id
        NavigationManager.inPrimaryWindow { navigationManager in
            navigationManager.resetFiltersAndSearch()
            navigationManager.sheet = .none
            navigationManager.universalLinkMensaId = mensaId
        }
        return .result()
    }
}
