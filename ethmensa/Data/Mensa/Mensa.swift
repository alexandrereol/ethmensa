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

import CoreTransferable
import MapKit
import os.log

#if !os(watchOS)
import SharedWithYou
#endif

/// Represents a canteen facility.
class Mensa: Identifiable {
    /// The logger for this Mensa.
    let logger: Logger
    /// The provider of this Mensa.
    let provider: APIProvider.ProviderType
    /// The facility ID of this Mensa.
    let facilityID: Int
    /// The id of this Mensa, e.g. "eth/123" or "uzh/456".
    var id: String {
        [provider.rawValue, String(facilityID)].joined(separator: "/")
    }
    /// The UI ID of this Mensa which forces SwiftUI to update when the opening times change.
    var uiID: String {
        [id, getOpeningTimes().rawValue].joined()
    }
    /// The name of this Mensa.
    let name: String
    /// The address of this Mensa.
    let location: String?
    /// The web URL of this Mensa.
    let webURL: URL?
    /// The image URL of this Mensa.
    let imageURL: URL?
    /// The meal times of this Mensa.
    var mealTimes: [MealTime]
    /// The share URL of this Mensa.
    var shareURL: URL {
        if let url = "https://ethmensa.ch/s/\(id)".toURL() {
            url
        } else {
            // Should never be reached
            "https://ethmensa.ch/s/".toURL()!
        }
    }

#if !os(watchOS)
    /// The SharedWithYou highlight of this Mensa.
    var swHighlight: SWHighlight?
#endif

    /// The cached campusType of this Mensa.
    internal var getLocationTypeCache: Campus.CampusType?
    /// The cached coordinates of this Mensa.
    internal var getCoordinatesCache: CLLocation?

    init(
        provider: APIProvider.ProviderType,
        facilityID: Int,
        name: String,
        location: String? = nil,
        webURL: URL? = nil,
        imageURL: URL? = nil,
        mealTimes: [MealTime]
    ) {
        self.logger = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: Mensa.self) + ": \(facilityID)"
        )
        self.provider = provider
        self.facilityID = facilityID
        self.name = name
        self.location = location
        self.webURL = webURL
        self.imageURL = imageURL
        self.mealTimes = mealTimes
    }
}

extension Mensa: Hashable, Equatable {
    static func == (lhs: Mensa, rhs: Mensa) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Mensa: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.shareURL)
    }
}

extension Mensa {
    /// An example Mensa for testing purposes
    static let example = Mensa(
        provider: .eth,
        facilityID: .random(in: 0...1_000_000),
        name: "Example Mensa",
        location: "Rämistrasse 101, 8006 Zürich",
        webURL: .init(string: "https://ethz.ch/"),
        // swiftlint:disable:next line_length
        imageURL: .init(string: "https://www.zuerich.com/sites/default/files/web_zuerich_eth_hauptgebaeude_1280x960_24298.jpg"),
        mealTimes: .init(repeating: .example, count: 2)
    )
}
