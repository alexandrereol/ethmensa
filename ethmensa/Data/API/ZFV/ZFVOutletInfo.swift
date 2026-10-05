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

/// Details about the UZH mensas that the ZFV API does not provide, e.g. the opening hours.
/// They come with the app in `zfv_uzh_mapping.json` and are updated from its copy on the `main` branch,
/// so they can be changed without an app release.
struct ZFVOutletInfo: Codable {
    /// The hours a meal time is served, e.g. from "11:00" to "14:30".
    struct Hours: Codable {
        let start: String
        let end: String
    }

    /// The id of the mensa in the former UZH API, if it was listed there. It is used as the facility ID,
    /// so that click counts, share links and shortcuts keep working.
    var uzhID: Int?
    /// The name of the mensa in the former UZH API, which is more descriptive than the ZFV name,
    /// e.g. "Mensa UZH Irchel" instead of "Mensa".
    var name: String?
    /// The address of the mensa, for the outlets without a location in the ZFV API.
    var address: String?
    /// The hours lunch is served.
    var lunch: Hours?
    /// The hours dinner is served.
    var dinner: Hours?

    /// The photo of the mensa, which is still served by the former UZH API.
    var imageURL: URL? {
        guard let uzhID else {
            return nil
        }
        return "https://ziuzhnowweb.uzh.ch/v3/mensa/\(uzhID)/image".toURL()
    }

    /// Returns the hours the given meal time is served.
    func hours(for serviceTime: ZFVConverter.ServiceTime) -> Hours? {
        switch serviceTime {
        case .lunch: lunch
        case .dinner: dinner
        }
    }
}

extension ZFVOutletInfo {
    private static let logger = Logger(
        subsystem: Bundle.main.safeIdentifier,
        category: String(describing: ZFVOutletInfo.self)
    )

    private static let host = "raw.githubusercontent.com"
    private static let path = "alexandrereol/ethmensa/refs/heads/main/ethmensa/Data/API/ZFV/zfv_uzh_mapping.json"
    private static let endpoint = "https://\(host)/\(path)"
    /// How long a downloaded copy is used before it is downloaded again.
    private static let cacheDuration: TimeInterval = 72 * 60 * 60
    private static let cacheKey = "zfvOutletInfo"
    private static let cacheDateKey = "zfvOutletInfoDate"

    /// The details of the UZH mensas from the last download, or the ones the app comes with if there was none.
    static func cached() -> [String: ZFVOutletInfo] {
        downloaded() ?? bundled() ?? [:]
    }

    /// Loads the details of the UZH mensas, keyed by the external id of the ZFV outlet.
    /// A downloaded copy is used for 72 hours. If the download fails, the last downloaded copy is used,
    /// or the one the app comes with.
    static func load() async -> [String: ZFVOutletInfo] {
        if let cacheDate = UserDefaults.standard.object(forKey: cacheDateKey) as? Date,
           cacheDate.timeIntervalSinceNow > -cacheDuration,
           let infos = downloaded() {
            return infos
        }
        guard let url = endpoint.toURL() else {
            logger.critical("\(#function): Could not create URL from endpoint")
            return cached()
        }
        let result = await API.shared.perform(
            url,
            host: host,
            resultType: [String: ZFVOutletInfo].self
        )
        switch result {
        case .success(let infos):
            if let data = try? JSONEncoder().encode(infos) {
                UserDefaults.standard.set(data, forKey: cacheKey)
                UserDefaults.standard.set(Date.now, forKey: cacheDateKey)
            }
            return infos
        case .failure(let error):
            logger.critical("\(#function): \(error)")
            return cached()
        }
    }

    /// The details of the last download, regardless of its age.
    private static func downloaded() -> [String: ZFVOutletInfo]? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else {
            return nil
        }
        return try? JSONDecoder().decode([String: ZFVOutletInfo].self, from: data)
    }

    /// The details the app comes with.
    private static func bundled() -> [String: ZFVOutletInfo]? {
        guard let url = Bundle.main.url(forResource: "zfv_uzh_mapping", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            logger.critical("\(#function): Could not read zfv_uzh_mapping.json")
            return nil
        }
        return try? JSONDecoder().decode([String: ZFVOutletInfo].self, from: data)
    }
}
