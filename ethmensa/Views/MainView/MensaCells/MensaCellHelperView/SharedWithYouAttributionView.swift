//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI
import SharedWithYou

struct SharedWithYouAttributionView: UIViewRepresentable {

    let highlight: SWHighlight
    let displayContext: SWAttributionView.DisplayContext

    func makeUIView(context: Context) -> SWAttributionView {
        .init()
    }

    func updateUIView(_ uiView: SWAttributionView, context: Context) {
        uiView.highlight = highlight
        uiView.displayContext = displayContext
    }
}
