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

/// Responsible for handling API requests and responses from some provider.
struct APIProvider {
    /// An enumeration representing the different types of API providers.
    enum ProviderType: String, CaseIterable {
        case eth
        case uzh
    }

    /// The type of provider, represented by the `ProviderType` enum.
    var type: ProviderType

    /// A variable conforming to the `APIProtocol` that provides the necessary API functionalities.
    var apiProtocol: APIProtocol

    /// A computed property that returns an array of all available API providers.
    static var allProviders: [APIProvider] {
        [
            APIProvider(type: .eth, apiProtocol: ETHAPI.shared),
            APIProvider(type: .uzh, apiProtocol: UZHAPI.shared)
        ]
    }
}
