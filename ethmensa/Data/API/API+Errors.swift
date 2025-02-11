//
//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

extension API {
    /// Extension of the `API` class to handle various error cases.
    enum Errors: Error, Equatable {
        /// Indicates a failure during the downloading process.
        case failedDownloading

        /// Indicates a failure during the decoding process.
        case failedDecoding

        /// Represents a custom local error with an associated message.
        case customLocalError(String)

        /// Represents a custom API error with an associated message.
        case customAPIerror(String)

        /// Represents an unknown error with an associated message.
        case unknownError(String)
    }

    /// Struct to represent errors returned by the Vapor framework.
    struct VaporError: Codable {
        /// A boolean indicating if an error occurred.
        let error: Bool

        /// A string describing the reason for the error.
        let reason: String
    }
}
