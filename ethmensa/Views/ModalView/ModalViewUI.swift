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

struct ModalViewUI: View {

    @Environment(\.horizontalSizeClass) private var hSizeClass
    @Environment(\.verticalSizeClass) private var vSizeClass

    var viewModel: ModalViewModel

    var body: some View {
        Group {
#if os(watchOS)
            ScrollView {
                VStack(spacing: 25) {
                    ModalAppView(viewModel: viewModel)
                    ModalLabelView(viewModel: viewModel)
                    ModalButtonView(viewModel: viewModel)
                }
            }
#else
            switch vSizeClass {
            case .compact:
                HStack(alignment: .center) {
                    Spacer()
                    VStack {
                        ModalAppView(viewModel: viewModel)
                            .frame(width: 200, height: 200)
                    }
                    Spacer()
                    VStack {
                        ModalLabelView(viewModel: viewModel)
                        ModalButtonView(viewModel: viewModel)
                    }
                    Spacer()
                }
            case .regular, .some, nil:
                VStack {
                    ModalAppView(viewModel: viewModel)
                        .padding(.top, 60)
                    Spacer()
                    ModalLabelView(viewModel: viewModel)
                    Spacer()
                    ModalButtonView(viewModel: viewModel)
                        .padding(.top, 20)
                }
            }
#endif
        }
    }
}

#Preview("About") {
    ModalViewUI(viewModel: .about)
}

#Preview("No internet") {
    ModalViewUI(viewModel: .noInternet)
}

#Preview("Update") {
    ModalViewUI(
        viewModel: .update(
            mainButtonAction: { },
            detailButtonAction: { })
    )
}
