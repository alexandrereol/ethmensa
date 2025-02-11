//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct SettingsETHVideoView: View {

    @Environment(\.openURL) var openURL

    private var isShown: Bool {
        !UIApplication.shared.canOpenURL("ethvideo://".toURL()!)
    }
    private var imageSize: CGFloat {
        if #available(iOS 17.0, *) {
            28
        } else {
            20
        }
    }

    var body: some View {
        if isShown {
            Button {
                openURL(String.appStoreETHVideoURLString.toURL()!)
            } label: {
                Label {
                    Text("CHECK_OUT_ETH_VIDEO!")
                } icon: {
                    Image(.appIconRoundedEthvideo)
                        .resizable()
                        .scaledToFit()
                        .frame(height: imageSize)
                }
            }
            .tint(.primary)
        }
    }
}

#Preview {
    List {
        SettingsETHVideoView()
    }
}
