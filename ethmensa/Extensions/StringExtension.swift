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
import os.log

extension String {
    /// Converts the string to a URL object.
    ///
    /// This method attempts to create a `URL` object from the string. If the string is a valid URL, it returns the
    /// URL object; otherwise, it returns `nil`.
    ///
    /// - Returns: An optional `URL` object if the string is a valid URL, otherwise `nil`.
    func toURL() -> URL? {
        URL(string: self)
    }
}
