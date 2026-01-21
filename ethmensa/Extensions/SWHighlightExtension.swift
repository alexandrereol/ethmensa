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

#if canImport(SharedWithYou)
import RegexBuilder
import SharedWithYou

extension SWHighlight {
    /// A computed property that extracts and returns the share ID from the URL's relative path.
    /// The share ID is determined by matching the relative path against a predefined regular expression.
    /// - Returns: An optional `String` containing the share ID if a match is found, otherwise `nil`.
    var shareID: String? {
        let mensaIdRef = Reference<Substring>()
        let regex = Regex {
            Optionally("/s/")
            Capture(as: mensaIdRef) {
                OneOrMore(.word)
                "/"
                OneOrMore(.digit)
            }
            Optionally("/")
        }
        return if let matchSubstring = url.relativePath.firstMatch(of: regex)?[mensaIdRef] {
            String(matchSubstring)
        } else {
            nil
        }
    }
}
#endif
