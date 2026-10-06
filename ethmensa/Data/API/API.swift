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
        subsystem: Bundle.main.safeIdentifier,
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

    /// The Mensa objects of a provider, as yielded by `get()`.
    struct ProviderMensas {
        let provider: APIProvider.ProviderType
        let mensas: [Mensa]
        /// Whether the Mensa objects were read from the cache of the provider instead of downloaded.
        let isCached: Bool
    }

    /// Fetches the Mensa objects of all providers in parallel.
    ///
    /// - Returns: A stream that yields the `Mensa` objects of each provider as soon as they are loaded.
    ///   Providers that cache their `Mensa` objects yield the cached ones first.
    func get() -> AsyncStream<ProviderMensas> {
        AsyncStream { continuation in
            let task = Task {
                await withTaskGroup(of: Void.self) { group in
                    for provider in APIProvider.allProviders {
                        group.addTask {
                            async let mensas = provider.apiProtocol.get()
                            if let cachedMensas = await provider.apiProtocol.cached() {
                                continuation.yield(.init(provider: provider.type, mensas: cachedMensas, isCached: true))
                            }
                            continuation.yield(.init(provider: provider.type, mensas: await mensas, isCached: false))
                        }
                    }
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
