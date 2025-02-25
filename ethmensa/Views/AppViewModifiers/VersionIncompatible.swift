//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
            logger.info("OUTDATED flag detected. Skipping version check.")
            return true
        } else if AppReleaseType.getCurrent == .debug {
            logger.info("Debug build detected. Skipping version check.")
            return false
        } else if NetworkManager.shared.isOffline {
            logger.info("No network connection. Skipping version check.")
            return false
        }
        let urlString = if CommandLine.arguments.contains("LOCALHOST") {
            "http://127.0.0.1/version?obj=1"
        } else {
            "https://\(host)/version?obj=1"
        }
        guard let url = urlString.toURL() else {
            logger.critical("Unable to create URL from string: \(urlString)")
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
                logger.critical("Error fetching build version number.")
                return false
            }
            return dataResult.data > build
        case .failure(let error):
            logger.critical("Error fetching version: \(error)")
            return false
        }
    }
}
