//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

private struct SettingsPermissionAlertModifiers: ViewModifier {

    @Binding var deniedShown: Bool
    @Binding var notSupportedShown: Bool

    var localizedDeniedPermission: String
    var deniedSettingsAction: () -> Void

    func body(content: Content) -> some View {
        content
            .alert(
                "PERMISSION_DENIED",
                isPresented: $deniedShown
            ) {
#if !targetEnvironment(macCatalyst)
                Button("OPEN_SETTINGS", role: .none) {
                    deniedSettingsAction()
                }
#endif
                Button("CLOSE", role: .cancel) { }
            } message: {
                Text("\(localizedDeniedPermission)_PERMISSION_DENIED_MESSAGE")
            }
            .alert(
                "NOT_SUPPORTED",
                isPresented: $notSupportedShown
            ) {
                Button("CLOSE", role: .cancel) { }
            } message: {
                Text("\(localizedDeniedPermission)_IS_NOT_SUPPORTED_ON_THIS_DEVICE")
            }
    }
}

extension View {
    func permissionAlerts(
        localizedDeniedPermission: String,
        deniedShown: Binding<Bool>,
        notSupportedShown: Binding<Bool>,
        deniedSettingsAction: @escaping () -> Void
    ) -> some View {
        self.modifier(
            SettingsPermissionAlertModifiers(
                deniedShown: notSupportedShown,
                notSupportedShown: deniedShown,
                localizedDeniedPermission: localizedDeniedPermission,
                deniedSettingsAction: deniedSettingsAction
            )
        )
    }
}
