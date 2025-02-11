//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Foundation

/// An enumeration representing the different types of app releases.
enum AppReleaseType: String {

    /// Represents the debug release type of the application.
    case debug = "Debug"

    /// Represents the test flight release type of the application.
    case testFlight = "TestFlight"

    /// Represents the app store release type of the application.
    case appStore = "AppStore"

    /// This property is used to determine the current release type of the application.
    static var getCurrent: AppReleaseType {
        if isDebug {
            .debug
        } else if isTestFlight {
            .testFlight
        } else {
            .appStore
        }
    }

    /// Indicates whether the app is running in a TestFlight environment.
    private static var isTestFlight: Bool {
        Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    }

    /// Indicates whether the app is running in debug mode.
    private static var isDebug: Bool {
#if DEBUG
        true
#else
        false
#endif
    }
}
