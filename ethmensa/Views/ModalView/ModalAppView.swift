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

struct ModalAppView: View {

    @State private var appIconPressActionCount = 0
    @State private var debugSheetShown = false

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
            Image(.appIconRoundedForUserVersion)
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
                        debugSheetShown = true
                    }
                }
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $debugSheetShown) {
            DebugView()
        }
    }
}

#Preview {
    ModalViewUI(viewModel: .about)
}
