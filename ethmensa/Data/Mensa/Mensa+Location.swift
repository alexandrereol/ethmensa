//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import CoreLocation

extension Mensa {
    /// Asynchronously retrieves the type of campus location.
    ///
    /// - Returns: An optional `Campus.CampusType` representing the type of campus location, or `nil`
    ///   if the type could not be determined.
    /// - Note: This function is asynchronous and should be awaited.
    func getLocationType() async -> Campus.CampusType? {
        if let getLocationTypeCache {
            return getLocationTypeCache
        } else if let result = await Campus.CampusType.getNearest(forMensa: self) {
            getLocationTypeCache = result
            return result
        } else {
            logger.critical("\(#function): failed getting Campus.CampusType.getNearest for \(self.name)")
            return nil
        }
    }

    /// Asynchronously retrieves the coordinates of the Mensa location.
    ///
    /// - Returns: An optional `CLLocation` object representing the coordinates of the Mensa location,
    ///   `nil` if the coordinates could not be retrieved.
    /// - Note: This function is asynchronous and should be awaited.
    func getCoordinates() async -> CLLocation? {
        if let getCoordinatesCache {
            return getCoordinatesCache
        }
        guard let location else {
            logger.critical("\(#function): failed for \(self.name) because location is nil")
            return nil
        }
        if let locationDBCache = GeoCacheDBManager.shared.read(
            address: location
        ) {
            return locationDBCache
        }
        var parsedAddress = location.replacingOccurrences(of: "\n", with: " ")
        do {
            // Using full address as provided by API
            return try await geocodeAddress(parsedAddress)
        } catch {
            do {
                // Using address without first line as probably building name
                var parsedAddressArray = location.components(separatedBy: "\n")
                parsedAddressArray = Array(parsedAddressArray.dropFirst())
                parsedAddress = parsedAddressArray.joined(separator: " ")
                return try await geocodeAddress(parsedAddress)
            } catch {
                logger.critical("\(#function): failed for \(parsedAddress) because \(error)")
                return nil
            }
        }
    }

    /// Geocodes the given address string into a CLLocation object.
    ///
    /// - Parameter address: The address string to be geocoded.
    /// - Returns: A CLLocation object representing the geocoded address, or nil if the geocoding fails.
    /// - Throws: An error if the geocoding process encounters an issue.
    private func geocodeAddress(_ address: String) async throws -> CLLocation? {
        if let location,
           let geocoderLocation = try await CLGeocoder()
            .geocodeAddressString(address)
            .compactMap(\.location)
            .first(where: { $0.horizontalAccuracy >= 0 }) {
            GeoCacheDBManager.shared.update(
                geoCache: .init(
                    address: location,
                    long: geocoderLocation.coordinate.longitude,
                    lat: geocoderLocation.coordinate.latitude
                )
            )
            let location = CLLocation(
                latitude: geocoderLocation.coordinate.latitude,
                longitude: geocoderLocation.coordinate.longitude
            )
            getCoordinatesCache = location
            return location
        } else {
            logger.critical("\(#function): failed for \(address) because geocoderLocation is nil")
            return nil
        }
    }
}
