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

struct ModalButtonView: View {

    var viewModel: ModalViewModel

    var body: some View {
        VStack {
            if let mainButtonLabel = viewModel.mainButtonLabel,
               let mainAction = viewModel.mainAction {
                Button {
                    mainAction()
                } label: {
                    Text(mainButtonLabel)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                }
                .frame(
                    maxWidth: .infinity,
                    minHeight: 60,
                    maxHeight: 60
                )
                .padding(.horizontal, 30)
                .foregroundColor(.white)
                .buttonStyle(.borderedProminent)
                .cornerRadius(15)
            }
            if let detailButtonLabel = viewModel.detailButtonLabel,
               let detailAction = viewModel.detailAction {
                Button(detailButtonLabel) {
                    detailAction()
                }
                .padding()
            }
        }
        .tint(viewModel.tintColor)
    }
}

#Preview {
    ModalViewUI(viewModel: .about)
}
