//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
