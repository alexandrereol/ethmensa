//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
