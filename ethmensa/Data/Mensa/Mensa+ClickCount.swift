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

extension Mensa {
    /// Increases the click count for the Mensa.
    /// 
    /// This function increments the internal counter that tracks the number of times
    /// the Mensa has been clicked or selected by the user.
    func increaseClicks() {
        ClickCountDBManager.shared.increaseByOne(id: id)
    }

    /// Retrieves the number of clicks.
    /// 
    /// - Returns: An integer representing the number of clicks.
    func getClicks() -> Int {
        if let count = ClickCountDBManager.shared.read(id: id) {
            count
        } else {
            // AR: Do not log, potentially never selected mensa
            -1
        }
    }
}
