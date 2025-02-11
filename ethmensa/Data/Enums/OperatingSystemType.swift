//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
