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

#if os(iOS)
import UIKit
#else
import Foundation
#endif

/// Enum to represent the different operating systems
enum OperatingSystemType: String {
    case macOScatalyst = "macOS Catalyst"
    case iOS = "iOS"
    case iPadOS = "iPadOS"
    case visionOS = "visionOS"
    case watchOS = "watchOS"
    case unknown

    /// Get the current operating system
    static var getCurrent: OperatingSystemType {
#if targetEnvironment(macCatalyst)
        .macOScatalyst
#elseif os(iOS)
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: .iOS
        case .pad: .iPadOS
        default: .unknown
        }
#elseif os(visionOS)
            .visionOS
#elseif os(watchOS)
            .watchOS
#elseif os(tvOS)
            .tvOS
#else
            .unknown
#endif
    }

    /// Get the current operating system as a string
    static var getOSVersionString: String {
#if os(iOS)
        UIDevice.current.systemVersion
#else
        let osv = ProcessInfo.processInfo.operatingSystemVersion
        let major = osv.majorVersion, minor = osv.minorVersion, patch = osv.patchVersion
        return "\(major).\(minor).\(patch)"
#endif
    }
}
