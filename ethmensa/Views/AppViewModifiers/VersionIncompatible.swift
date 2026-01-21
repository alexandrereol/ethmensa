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

class VersionIncompatible: ObservableObject {
    static private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: VersionIncompatible.self)
    )

    private struct Result: Codable {
        let data: Int
    }

    static func fetchVersionCompatible(host: String) async -> Bool {
        if CommandLine.arguments.contains("OUTDATED") {
            logger.info("\(#function): OUTDATED flag detected. Skipping version check.")
            return true
        } else if AppReleaseType.getCurrent == .debug {
            logger.info("\(#function): Debug build detected. Skipping version check.")
            return false
        } else if NetworkManager.shared.isOffline {
            logger.info("\(#function): No network connection. Skipping version check.")
            return false
        }
        let urlString = if CommandLine.arguments.contains("LOCALHOST") {
            "http://127.0.0.1/version?obj=1"
        } else {
            "https://\(host)/version?obj=1"
        }
        guard let url = urlString.toURL() else {
            logger.critical("\(#function): Unable to create URL from string: \(urlString)")
            return false
        }
        switch await API.shared.perform(
            url,
            host: host,
            resultType: Result.self
        ) {
        case .success(let dataResult):
            guard let buildString = Bundle.main.buildVersionNumberString,
                  let build = Int(buildString) else {
                logger.critical("\(#function): Error fetching build version number.")
                return false
            }
            return dataResult.data > build
        case .failure(let error):
            logger.critical("\(#function): Error fetching version: \(error)")
            return false
        }
    }
}
