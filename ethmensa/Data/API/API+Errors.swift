//
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
