//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI
import StoreKit

struct SKOverlayModifier: ViewModifier {

    @State var showSKOverlay = false

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
