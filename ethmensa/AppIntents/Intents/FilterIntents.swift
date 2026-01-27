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

struct CurrentlyOpenIntent: AppIntent {
    static let title: LocalizedStringResource = "OPEN_APP_AND_SHOW_CURRENTLY_OPEN"

    static let openAppWhenRun: Bool = true

    @Dependency var mensaDataManager: MensaDataManager
    @Dependency var navigationManager: NavigationManager
    @Dependency var settingsManager: SettingsManager

    @MainActor
    func perform() async throws -> some IntentResult {
        navigationManager.selectedMensa = nil
        await mensaDataManager.resetFiltersAndSearch()
        settingsManager.mensaShowType = .open
        navigationManager.sheet = .none
        return .result()
    }
}

struct ZentrumIntent: AppIntent {
    static let title: LocalizedStringResource = "OPEN_APP_AND_SHOW_ZENTRUM_MENSAS"

    static let openAppWhenRun: Bool = true

    @Dependency var mensaDataManager: MensaDataManager
    @Dependency var navigationManager: NavigationManager
    @Dependency var settingsManager: SettingsManager

    @MainActor
    func perform() async throws -> some IntentResult {
        navigationManager.selectedMensa = nil
        await mensaDataManager.resetFiltersAndSearch()
        settingsManager.mensaLocationType = .zentrum
        navigationManager.sheet = .none
        return .result()
    }
}

struct HonggIntent: AppIntent {
    static let title: LocalizedStringResource = "OPEN_APP_AND_SHOW_HONGG_MENSAS"

    static let openAppWhenRun: Bool = true

    @Dependency var mensaDataManager: MensaDataManager
    @Dependency var navigationManager: NavigationManager
    @Dependency var settingsManager: SettingsManager

    @MainActor
    func perform() async throws -> some IntentResult {
        navigationManager.selectedMensa = nil
        await mensaDataManager.resetFiltersAndSearch()
        settingsManager.mensaLocationType = .hongg
        navigationManager.sheet = .none
        return .result()
    }
}

struct IrchelIntent: AppIntent {
    static let title: LocalizedStringResource = "OPEN_APP_AND_SHOW_IRCHEL_MENSAS"

    static let openAppWhenRun: Bool = true

    @Dependency var mensaDataManager: MensaDataManager
    @Dependency var navigationManager: NavigationManager
    @Dependency var settingsManager: SettingsManager

    @MainActor
    func perform() async throws -> some IntentResult {
        navigationManager.selectedMensa = nil
        await mensaDataManager.resetFiltersAndSearch()
        settingsManager.mensaLocationType = .irchel
        navigationManager.sheet = .none
        return .result()
    }
}
