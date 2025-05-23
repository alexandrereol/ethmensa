//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import StoreKit
import SwiftUI

struct SKOverlayModifier: ViewModifier {

    @State private var showSKOverlay = false

    func body(content: Content) -> some View {
        content
            .appStoreOverlay(isPresented: $showSKOverlay) {
                SKOverlay.AppClipConfiguration(position: .bottom)
            }
            .onAppear {
                showSKOverlay = true
            }
    }
}

extension View {
    func skOverlay() -> some View {
        self.modifier(SKOverlayModifier())
    }
}
