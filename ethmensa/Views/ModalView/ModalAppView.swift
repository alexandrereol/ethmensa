//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct ModalAppView: View {

    @State var appIconPressActionCount = 0

    var viewModel: ModalViewModel

    var body: some View {
        VStack(spacing: 15) {
#if !os(watchOS)
            Text(viewModel.title)
                .bold()
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.25)
#endif
            Image(.appIconRounded)
                .resizable()
                .scaledToFit()
#if os(watchOS)
                .frame(width: 30, height: 30)
#else
                .frame(width: 135, height: 135)
#endif
                .onTapGesture {
                    appIconPressActionCount += 1
                }
                .onChange(of: appIconPressActionCount) { newValue in
                    if newValue >= 10 {
                        appIconPressActionCount = 0
                        viewModel.appIconPressAction?()
                    }
                }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ModalViewUI(viewModel: .about())
}
