//
//  Copyright © 2026 Alexandre Reol
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <https://www.gnu.org/licenses/>.
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
                if #available(iOS 26.0, visionOS 26.0, *) {
                    Button(role: .close) {
                        deniedShown = false
                    }
                } else {
                    Button("CLOSE") {
                        deniedShown = false
                    }
                }
            } message: {
                Text("\(localizedDeniedPermission)_PERMISSION_DENIED_MESSAGE")
            }
            .alert(
                "NOT_SUPPORTED",
                isPresented: $notSupportedShown
            ) {
                if #available(iOS 26.0, visionOS 26.0, *) {
                    Button(role: .close) {
                        notSupportedShown = false
                    }
                } else {
                    Button("CLOSE") {
                        notSupportedShown = false
                    }
                }
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
