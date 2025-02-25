//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Combine
import Foundation

class AdvancedSettingsViewModel: ObservableObject {

    @Published var resetSmartSortingAlertShown = false
    @Published var resetAppleMapsCacheAlertShown = false
    @Published var resetSettingsAlertShown = false
    @Published var resetSettingsAndDataAlertShown = false

    private let udf = SettingsManager.shared.udf
    private let kvs = SettingsManager.shared.kvs

    func resetSmartSorting() {
        ClickCountDBManager.shared.reset()
    }

    func resetAppleMapsCache() {
        GeoCacheDBManager.shared.reset()
    }

    func resetSettings() {
        for key in udf.dictionaryRepresentation().keys where SettingsManager.Prefix.isPrefixMatching(key: key) {
            udf.removeObject(forKey: key)
        }
        for key in kvs.dictionaryRepresentation.keys where SettingsManager.Prefix.isPrefixMatching(key: key) {
            kvs.removeObject(forKey: key)
        }
        SettingsManager.shared.launchAndMigrate()
    }

    func resetSettingsAndData() {
        for key in udf.dictionaryRepresentation().keys where SettingsManager.Prefix.isPrefixMatching(key: key) {
            udf.removeObject(forKey: key)
        }
        for key in kvs.dictionaryRepresentation.keys where SettingsManager.Prefix.isPrefixMatching(key: key) {
            kvs.removeObject(forKey: key)
        }
        resetSmartSorting()
        resetAppleMapsCache()
        SettingsManager.shared.launchAndMigrate()
    }
}
