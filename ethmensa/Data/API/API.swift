//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Foundation
import os.log

/// Responsible for handling API requests and responses.
class API {
     /// A singleton instance of `API`
    /// 
    /// Use `API.shared` to access the shared instance.
    static let shared = API()

    /// A logger instance for the `API` class.
    ///
    /// This logger is initialized with the app's bundle identifier as the subsystem
    /// and the name of the `API` class as the category. It is used to
    /// log messages related to the operations and events within the API.
    internal let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: API.self)
    )

    /// A computed property that returns the appropriate host URL based on the current app release type.
    /// - Returns: A `String` representing the host URL.
    /// - Note: The host URL is determined by the `AppReleaseType.getCurrent` value.
    ///   - For `.debug`, it returns "dev.api.ethmensa.reol.ch".
    ///   - For `.testFlight` and `.appStore`, it returns "api.ethmensa.reol.ch".
    var host: String {
        switch AppReleaseType.getCurrent {
        case .debug: "dev.api.ethmensa.reol.ch"
        case .testFlight, .appStore: "api.ethmensa.reol.ch"
        }
    }

    /// The endpoint for the API request.
    /// 
    /// This property should return the specific endpoint as a `String`
    var endpoint: String {
        if CommandLine.arguments.contains("LOCALHOST") {
            "http://127.0.0.1:8080"
        } else {
            "https://\(host)"
        }
    }

    /// Asynchronously fetches a list of Mensa objects of all providers.
    ///
    /// - Returns: An array of `Mensa` objects over all providers.
    func get() async -> [Mensa] {
        var mensaArray: [Mensa] = []
        for api in APIProvider.allProviders.map(\.apiProtocol) {
            mensaArray = await mensaArray + api.get()
        }
        return mensaArray
    }
}
