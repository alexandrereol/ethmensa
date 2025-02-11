//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import AppIntents
import CoreSpotlight

@available(iOS 18.0, *)
extension MensaEntity: IndexedEntity {
    var attributeSet: CSSearchableItemAttributeSet {
        let existingAttributes = defaultAttributeSet
        existingAttributes.displayName = name
        existingAttributes.title = name
        existingAttributes.associateAppEntity(self)
        return existingAttributes
    }
}
