//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Foundation

extension ProcessInfo {
    /// A computed property that checks if the current process is running in Xcode's preview mode.
    /// 
    /// This property reads the `XCODE_RUNNING_FOR_PREVIEWS` environment variable and returns `true` if its value is
    /// "1", indicating that the process is running in Xcode's SwiftUI preview mode.
    /// 
    /// - Returns: A Boolean value indicating whether the current process is running in Xcode's preview mode.
    static var isXcodePreview: Bool {
        self.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
