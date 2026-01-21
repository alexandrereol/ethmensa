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

extension Bundle {
    /// A computed property that retrieves the release version number string from the app's Info.plist file.
    /// 
    /// This property accesses the `CFBundleShortVersionString` key in the app's `infoDictionary` to obtain the release
    /// version number.
    ///
    /// - Returns: An optional `String` containing the release version number, or `nil` if the key is not found.
    var releaseVersionNumberString: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }

    /// A computed property that retrieves the build version number of the app from the bundle's info dictionary.
    /// 
    /// This property accesses the `CFBundleVersion` key in the bundle's info dictionary and returns its value as a
    /// `String`.
    ///
    /// - Returns: A `String` representing the build version number, or `nil` if the key does not exist or the value
    /// is not a `String`.
    var buildVersionNumberString: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }

    /// A computed property that retrieves the display name of the app from the 
    /// Info.plist file. If the "CFBundleDisplayName" key is not found, it defaults 
    /// to "ETH Mensa".
    ///
    /// - Returns: The display name of the app as a `String`.
    var displayName: String {
        object(
            forInfoDictionaryKey: "CFBundleDisplayName"
        ) as? String ?? "ETH Mensa"
    }
}
