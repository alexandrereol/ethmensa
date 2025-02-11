//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
