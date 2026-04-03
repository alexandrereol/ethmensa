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

/// An enumeration representing the different types of devices.
enum DeviceType: String {
    /// Represents the Mac device type.
    case mac = "Mac"

    /// Represents the iPhone device type.
    case iPhone = "iPhone"

    /// Represents the iPad device type.
    case iPad = "iPad"

    /// Represents the Vision Pro device type.
    case visionPro = "Vision Pro"

    /// Represents the Apple Watch device type.
    case appleWatch = "Apple Watch"

    /// Represents the Apple TV device type.
    case unknown

    /// This property is used to determine the current device type.
    static var getCurrent: DeviceType {
#if os(macOS) || targetEnvironment(macCatalyst)
        .mac
#elseif os(iOS)
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: .iPhone
        case .pad: .iPad
        default: .unknown
        }
#elseif os(visionOS)
            .visionPro
#elseif os(watchOS)
            .appleWatch
#else
            .unknown
#endif
    }
}
