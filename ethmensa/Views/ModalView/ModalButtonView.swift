//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
    ModalViewUI(viewModel: .about())
}
