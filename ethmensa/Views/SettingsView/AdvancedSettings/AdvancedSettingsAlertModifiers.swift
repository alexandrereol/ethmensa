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
