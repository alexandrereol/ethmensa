//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
