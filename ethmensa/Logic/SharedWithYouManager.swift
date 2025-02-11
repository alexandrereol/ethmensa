//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import os.log
import Foundation
import SharedWithYou

/// Responsible for managing shared content within the application.
class SharedWithYouManager: NSObject, SWHighlightCenterDelegate {
    /// A singleton instance of `SharedWithYouManager` to manage mensa data.
    ///
    /// Use `SharedWithYouManager.shared` to access the shared instance.
    static let shared = SharedWithYouManager()

    /// A logger instance for the `SharedWithYouManager` class.
    ///
    /// This logger is initialized with the app's bundle identifier as the subsystem
    /// and the name of the `SharedWithYouManager` class as the category. It is used to
    /// log messages related to the operations and events within the SharedWithYouManager.
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: SharedWithYouManager.self)
    )

    /// An array of current`SWHighlight` objects.
    var swHighlights: [SWHighlight]?

    /// A private property that holds a reference to the SWHighlightCenter instance.
    /// This is used to manage and interact with the highlight center functionality.
    private let highlightCenter: SWHighlightCenter

    override init() {
        self.highlightCenter = SWHighlightCenter()
        super.init()
        highlightCenter.delegate = self
    }

    /// Updates the `swHighlights` property with the highlights from the provided `SWHighlightCenter`
    /// and logs the new count of highlights.
    ///
    /// - Parameter highlightCenter: The `SWHighlightCenter` instance containing the updated highlights.
    func highlightCenterHighlightsDidChange(_ highlightCenter: SWHighlightCenter) {
        self.swHighlights = highlightCenter.highlights
        logger.info("highlightCenterHighlightsDidChange(): new count: \(highlightCenter.highlights.count)")
    }

    /// Handles the "Shared With You" highlights by filtering and reordering the provided `mensaArray`.
    ///
    /// This function filters the `swHighlights` to find those that match the IDs in the `mensaArray`.
    /// It then takes the first two matches, reverses their order, and moves them to the front of the `mensaArray`.
    ///
    /// - Parameter mensaArray: An inout array of `Mensa` objects that will be modified by the function.
    /// - Note: The function assumes that `swHighlights` is a non-optional collection of highlights.
    /// - Warning: If `swHighlights` is nil, the function will return early without modifying `mensaArray`.
    func sharedWithYouHandler(_ mensaArray: inout [Mensa]) {
        guard let swHighlights else {
            return
        }
        let filteredSWHighlights = swHighlights.filter { swHighlight in
            mensaArray.contains(where: { $0.id == swHighlight.shareID })
        }.prefix(2).reversed()
        for swHighlight in filteredSWHighlights {
            guard let swHiglightMensaId = swHighlight.shareID else {
                continue
            }
            let index = mensaArray.map(\.id).firstIndex(of: swHiglightMensaId)
            let mensa = mensaArray.remove(at: index!)
            mensa.swHighlight = swHighlight
            mensaArray.insert(mensa, at: 0)
        }
    }
}
