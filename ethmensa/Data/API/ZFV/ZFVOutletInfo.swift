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

import Foundation
import os.log

/// Details about the UZH mensas that the ZFV API does not provide.
/// They are loaded from `zfv_uzh_mapping.json` in the repository, so they can be updated without an app release.
struct ZFVOutletInfo: Codable {
    /// The id of the mensa in the former UZH API, if it was listed there. It is used as the facility ID,
    /// so that click counts, share links and shortcuts keep working.
    var uzhID: Int?
    /// The name of the mensa in the former UZH API, which is more descriptive than the ZFV name,
    /// e.g. "Mensa UZH Irchel" instead of "Mensa".
    var name: String?
    /// The address of the mensa, for the outlets without a location in the ZFV API.
    var address: String?

    /// The photo of the mensa, which is still served by the former UZH API.
    var imageURL: URL? {
        guard let uzhID else {
            return nil
        }
        return "https://ziuzhnowweb.uzh.ch/v3/mensa/\(uzhID)/image".toURL()
    }
}

extension ZFVOutletInfo {
    private static let logger = Logger(
        subsystem: Bundle.main.safeIdentifier,
        category: String(describing: ZFVOutletInfo.self)
    )

    private static let host = "raw.githubusercontent.com"
    private static let endpoint = "https://\(host)/alexandrereol/ethmensa/refs/heads/main/zfv_uzh_mapping.json"
    /// How long a downloaded copy is used before it is downloaded again.
    private static let cacheDuration: TimeInterval = 72 * 60 * 60
    private static let cacheKey = "zfvOutletInfo"
    private static let cacheDateKey = "zfvOutletInfoDate"

    /// Loads the details of the UZH mensas, keyed by the external id of the ZFV outlet.
    /// A downloaded copy is used for 72 hours. If the file cannot be downloaded, no details are returned
    /// and the UZH mensas are shown with the ZFV data only, e.g. with the ZFV names.
    static func load() async -> [String: ZFVOutletInfo] {
        let defaults = UserDefaults.standard
        if let cacheDate = defaults.object(forKey: cacheDateKey) as? Date,
           cacheDate.timeIntervalSinceNow > -cacheDuration,
           let data = defaults.data(forKey: cacheKey),
           let infos = try? JSONDecoder().decode([String: ZFVOutletInfo].self, from: data) {
            return infos
        }
        guard let url = endpoint.toURL() else {
            logger.critical("\(#function): Could not create URL from endpoint")
            return [:]
        }
        let result = await API.shared.perform(
            url,
            host: host,
            resultType: [String: ZFVOutletInfo].self
        )
        switch result {
        case .success(let infos):
            if let data = try? JSONEncoder().encode(infos) {
                defaults.set(data, forKey: cacheKey)
                defaults.set(Date.now, forKey: cacheDateKey)
            }
            return infos
        case .failure(let error):
            logger.critical("\(#function): \(error)")
            return [:]
        }
    }
}
