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
