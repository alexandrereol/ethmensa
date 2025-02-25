//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
