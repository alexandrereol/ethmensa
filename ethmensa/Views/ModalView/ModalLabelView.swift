//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct ModalLabelView: View {

    var viewModel: ModalViewModel

    var body: some View {
        VStack(spacing: 15) {
            if let label1 = viewModel.label1 {
                Text(label1)
                    .bold()
            }
            if let label2 = viewModel.label2 {
                Text(label2)
            }
        }
        .padding(.horizontal, 20)
        .multilineTextAlignment(.center)
    }
}

#Preview {
    ModalViewUI(viewModel: .about)
}
