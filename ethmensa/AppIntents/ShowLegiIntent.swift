//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import AppIntents
import SwiftUI

#if !targetEnvironment(macCatalyst)
struct ShowLegiIntent: AppIntent {
    static let title: LocalizedStringResource = "SHOW_LEGI_CARD"
    static let description: IntentDescription? = "SHOW_LEGI_CARD_DESCRIPTION"

    static let openAppWhenRun: Bool = true

    @Dependency var navigationManager: NavigationManager

    @MainActor
    func perform() async throws -> some IntentResult {
        navigationManager.sheet = .legiCard
        return .result()
    }
}
#endif
