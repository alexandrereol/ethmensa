//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Foundation

extension API {
    /// Prepares a URLRequest with the necessary configurations.
    ///
    /// This method sets up the URLRequest with the appropriate HTTP url, host, and headers.
    ///
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - host: The host to include in the header of the request.
    ///   - headers: A dictionary of headers to include in the request.
    /// - Returns: A configured URLRequest object.
    private func prepareRequest(
        _ url: URL,
        host: String? = nil,
        headers: [String: String]? = nil
    ) -> URLRequest {
        var request = URLRequest(url: url)
        if CommandLine.arguments.contains("LOCALHOST") {
            guard let host else {
                logger.critical("prepareRequest(): Using LOCALHOST but did    not specify a host in the header")
                fatalError()
            }
            request.addValue(host, forHTTPHeaderField: "Host")
        }
        if let headers {
            for key in headers.keys {
                request.setValue(headers[key], forHTTPHeaderField: key)
            }
        }
        return request
    }

    /// Decodes the error from the given data.
    ///
    /// - Parameter data: The data to decode the error from.
    /// - Returns: An `API.Errors` object representing the decoded error.
    private func decodeError(_ data: Data) -> API.Errors {
        do {
            logger.info("decodeError(): Decoding error")
            let result = try JSONDecoder().decode(API.VaporError.self, from: data)
            logger.error("decodeError(): \(result.reason)")
            return .customAPIerror(result.reason)
        } catch {
            logger.info("decodeError(): Failed decoding as API.VaporError, trying String")
            if let result = String(data: data, encoding: .utf8) {
                logger.error("decodeError(): \(result)")
                return .unknownError(result)
            } else {
                logger.critical("decodeError(): Failed decoding as API.VaporError and String")
                return .failedDecoding
            }
        }
    }

    /// Performs a network request and decodes the response into the specified type.
    ///
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - host: The host to include in the header of the request.
    ///   - headers: A dictionary of headers to include in the request.
    ///   - resultType: The type to decode the response into.
    ///  
    /// - Returns: An object of type resultType containing the decoded response or an error.
    func perform<T>(
        _ url: URL,
        host: String? = nil,
        headers: [String: String]? = nil,
        resultType: T.Type
    ) async -> Result<T, API.Errors> {
        let request = prepareRequest(
            url,
            host: host,
            headers: headers
        )
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let resultType = resultType as? Decodable.Type {
                do {
                    guard let result = try JSONDecoder().decode(resultType, from: data) as? T else {
                        logger.critical("perform<T>(): ")
                        return decodeData(data: data, resultType: T.self)
                    }
                    return .success(result)
                } catch {
                    logger.critical("perform<T>(): \(error)")
                    return decodeData(data: data, resultType: T.self)
                }
            } else {
                return decodeData(data: data, resultType: T.self)
            }
        } catch {
            logger.critical("perform<T>(): \(error)")
            return .failure(.failedDownloading)
        }
    }

    /// Decodes the given data into the specified type.
    ///
    /// - Parameter data: The data to decode.
    /// - Returns: An instance of the specified type, if the data can be decoded successfully.
    private func decodeData<T>(
        data: Data,
        resultType: T.Type = Data.self
    ) -> Result<T, API.Errors> {
        return if resultType is String.Type {
            if let result = String(data: data, encoding: .utf8) as? T {
                .success(result)
            } else {
                .failure(.failedDecoding)
            }
        } else if let result = data as? T {
            .success(result)
        } else {
            .failure(decodeError(data))
        }
    }
}
