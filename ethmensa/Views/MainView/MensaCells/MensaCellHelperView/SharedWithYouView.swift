//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI
import SharedWithYou

struct SharedWithYouView: View {

    var swhighlight: SWHighlight?

    var body: some View {
        Group {
            if ProcessInfo.isXcodePreview {
                Text(String("SWAttributionView"))
                    .background(.green)
            } else if let swhighlight = swhighlight {
                SharedWithYouAttributionView(
                    highlight: swhighlight,
                    displayContext: .summary
                )
            }
        }
        .frame(height: 10)
    }
}
