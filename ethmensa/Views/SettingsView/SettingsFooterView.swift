//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct SettingsFooterView: View {

    @Environment(\.openURL) private var openURL

    @State private var shareSheetShown = false
    @State private var privacyPolicyPresented = false

    private var isETHVideoPromotionShown: Bool {
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
        Section {
            Button(
                "SHARE_APP",
                systemImage: "square.and.arrow.up.fill"
            ) {
                shareSheetShown = true
            }
            .popover(isPresented: $shareSheetShown) {
                UIActivityView(
                    name: Bundle.main.displayName,
                    url: String.appStoreURLString.toURL()!,
                    image: .appIconRounded,
                    excludedActivityTypes: []
                )
                .presentationDetents([.medium])
            }
            Button(
                "REVIEW_ON_APP_STORE",
                systemImage: "star.bubble.fill"
            ) {
                openURL(URL.getAppStoreReviewURL!)
            }
            Button(
                "PRIVACY_POLICY",
                systemImage: "doc.text.fill"
            ) {
#if targetEnvironment(macCatalyst) || os(visionOS)
                openURL(String.privacyPolicyURLString.toURL()!)
#else
                privacyPolicyPresented = true
#endif
            }
            .fullScreenCover(isPresented: $privacyPolicyPresented) {
                SafariWebView(url: String.privacyPolicyURLString.toURL()!)
                    .ignoresSafeArea()
            }
        }
        .tint(.primary)
        Section {
            Button {
                openURL(String.whatsAppURLString.toURL()!)
            } label: {
                Label(
                    "LIVE_SUPPORT_OVER_WHATSAPP",
                    systemImage: "bubble.fill"
                )
            }
            Button(
                "SUPPORT_OVER_EMAIL",
                systemImage: "envelope.fill"
            ) {
                openURL(String.emailURLString.toURL()!)
            }
        }
        .tint(.primary)
        Section {
            if isETHVideoPromotionShown {
                Button {
                    openURL("https://apps.apple.com/app/id6458144304".toURL()!)
                } label: {
                    Label {
                        Text("CHECK_OUT_ETH_VIDEO!")
                    } icon: {
                        Image(.appIconRoundedEthvideo)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: imageSize,
                                height: imageSize
                            )
                    }
                }
                .tint(.primary)
            }
            NavigationLink {
                ModalViewUI(viewModel: .about)
            } label: {
                Label {
                    Text("ABOUT_\(Bundle.main.displayName)")
                        .tint(.primary)
                } icon: {
                    Image(.appIconRounded)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: imageSize,
                            height: imageSize
                        )
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        List {
            SettingsFooterView()
        }
    }
}
