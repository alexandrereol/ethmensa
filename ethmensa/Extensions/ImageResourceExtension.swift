//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

extension ImageResource {
    static var appIconRoundedForUserVersion: ImageResource {
        if #available(iOS 26.0, watchOS 26.0, *) {
            .appIconRoundedLG

        } else {
            .appIconRounded
        }
    }
    static var appETHVideoIconRoundedForUserVersion: ImageResource {
        if #available(iOS 26.0, watchOS 26.0, *) {
            .appIconRoundedLGEthvideo
        } else {
            .appIconRoundedEthvideo
        }
    }
}
