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

import CoreLocation
import Foundation
import os.log

/// A structure representing a campus.
struct Campus {
    static let logger = Logger(
        subsystem: Bundle.main.safeIdentifier,
        category: String(describing: Campus.self)
    )

    let location: CLLocation
    let type: Campus.CampusType

    /// An enumeration representing the various campus types.
    enum CampusType: String, CaseIterable {
        /// Represents all campuses.
        case all

        /// Represents the Zentrum campus.
        case zentrum

        /// Represents the Irchel campus.
        case irchel

        /// Represents the Honggerberg campus.
        case hongg

        /// A computed property that returns the localized string of the campus type.
        var localizedString: String {
            switch self {
            case .all: .init(localized: "ALL_LOCATIONS")
            case .zentrum: .init(localized: "ZENTRUM")
            case .irchel: .init(localized: "IRCHEL")
            case .hongg: .init(localized: "HONGGERBERG")
            }
        }

        /// A computed property that returns the campus matching the given Mensa if one is matching.
        static func getNearest(forMensa mensa: Mensa) async -> Self? {
            guard let mensaLocation = await mensa.getCoordinates() else {
                Campus.logger.critical("\(#function): Could not get coordinates")
                return nil
            }
            let result = allCampuses.map { campus -> (campus: Campus.CampusType, distance: Double) in
                (campus.type, mensaLocation.distance(from: campus.location))
            }.min { lhs, rhs in
                lhs.distance < rhs.distance
            }
            guard let result else {
                Campus.logger.critical("\(#function): Could not get nearest campus")
                return nil
            }
            if result.distance > 1000 {
                logger.info("\(#function): Nearest campus is more than 1000m away")
                return nil
            } else {
                return result.campus
            }
        }
    }

    /// A static property that returns all campuses.
    static var allCampuses: [Campus] {
        [
            .init(
                location: CLLocation(
                    latitude: 47.377399461702936,
                    longitude: 8.548341273815552
                ),
                type: .zentrum
            ),
            .init(
                location: CLLocation(
                    latitude: 47.40862508665355,
                    longitude: 8.50779324765029
                ),
                type: .hongg
            ),
            .init(
                location: CLLocation(
                    latitude: 47.39747781967301,
                    longitude: 8.549434449904433
                ),
                type: .irchel
            )
        ]
    }
}
