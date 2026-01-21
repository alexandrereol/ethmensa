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
