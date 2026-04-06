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

import Apollo
import ApolloAPI
import Foundation
import os.log

class ZFVGraphQLClient {
    static let shared = ZFVGraphQLClient()

    private let logger = Logger(
        subsystem: Bundle.main.safeIdentifier,
        category: String(describing: ZFVGraphQLClient.self)
    )

    private let client: ApolloClient = {
        let store = ApolloStore()
        // swiftlint:disable:next line_length
        let apiKey = "Y205NnFzenc4OGw2bnM2MHQ2MGh6OTlvdTpacE1aTGpUNFAxK1dJM0RmWUNsSXdoS3hXQldXUE5USHhRUmcxUUhZUnZCOWp1N3JadHFxOUZkUXNMdGVmSFI5"
        let transport = RequestChainNetworkTransport(
            interceptorProvider: DefaultInterceptorProvider(store: store),
            endpointURL: URL(string: "https://api.zfv.ch/graphql")!,
            additionalHeaders: [
                "api-key": apiKey,
                "locale": Bundle.main.preferredLocalizations.first ?? "de"
            ]
        )
        return ApolloClient(networkTransport: transport, store: store)
    }()

    func getMensas() async -> ZFVGraph.MensasQuery.Data? {
        do {
            let result = try await client.fetchAsync(
                query: ZFVGraph.MensasQuery()
            )
            if let errors = result.errors, !errors.isEmpty {
                logger.error("\(#function): Apollo returned GraphQL errors: \(errors)")
            }
            return result.data
        } catch {
            logger.critical("\(#function): \(error)")
            return nil
        }
    }
}
