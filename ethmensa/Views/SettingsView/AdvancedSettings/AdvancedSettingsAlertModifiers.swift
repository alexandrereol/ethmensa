//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

private struct AdvancedSettingsAlertModifiers: ViewModifier {

    @Binding var isPresented: Bool

    var title: String
    var confirmAction: () -> Void

    func body(content: Content) -> some View {
        content
            .alert(
                title,
                isPresented: $isPresented
            ) {
                Button("YES", role: .destructive) {
                    confirmAction()
                }
                Button("NO", role: .cancel) { }
            } message: {
                Text("THIS_ACTION_IS_IRREVERSIBLE")
            }
    }
}

extension View {
    func advancedSettingsAlert(
        isPresented: Binding<Bool>,
        title: String,
        confirmAction: @escaping () -> Void
    ) -> some View {
        self.modifier(
            AdvancedSettingsAlertModifiers(
                isPresented: isPresented,
                title: title,
                confirmAction: confirmAction
            )
        )
    }
}
