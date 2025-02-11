//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
