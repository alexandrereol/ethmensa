//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
#elseif os(tvOS)
            .appleTV
#else
            .unknown
#endif
    }
}
