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
