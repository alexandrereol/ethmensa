//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Foundation

extension Array {
    /// A computed property that returns the second element of the array if it exists.
    /// - Returns: The second element of the array, or `nil` if the array has fewer than two elements.
    var second: Self.Element? {
        if 2 > self.count {
            nil
        } else {
            self[1] as Self.Element
        }
    }

    /// A computed property that returns the third element of the array if it exists.
    /// - Returns: The third element of the array if the array has at least three elements; otherwise, `nil`.
    var third: Self.Element? {
        if 3 > self.count {
            nil
        } else {
            self[2] as Self.Element
        }
    }
}

extension Array where Element: Equatable {
    /// A computed property that returns an array containing only the unique elements of the original array.
    /// 
    /// This property iterates through the array and appends elements to a new array only if they are not already
    /// present.
    ///
    /// - Returns: An array of unique elements.
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}
