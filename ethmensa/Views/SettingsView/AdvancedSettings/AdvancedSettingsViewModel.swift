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
