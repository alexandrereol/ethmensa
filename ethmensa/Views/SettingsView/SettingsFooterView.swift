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

struct SettingsFooterView: View {

    @Environment(\.openURL) private var openURL

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
            ShareLink(
                item: String.appStoreURLString.toURL()!,
                preview: .init(
                    Bundle.main.displayName,
                    image: Image(uiImage: .appIconRoundedForUserVersion)
                )
            ) {
                Label(
                    "SHARE_APP",
                    systemImage: "square.and.arrow.up.fill"
                )
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
        } header: {
            Spacer(minLength: 10).listRowInsets(EdgeInsets())
        }
        .tint(.primary)
        Section {
            Menu {
                Button(String("WhatsApp")) {
                    openURL(String.whatsAppURLString.toURL()!)
                }
                Button("EMAIL") {
                    openURL(String.emailURLString.toURL()!)
                }
            } label: {
                Label(
                    "CONTACT",
                    systemImage: "bubble.left.and.bubble.right.fill"
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
        } header: {
            Spacer(minLength: 10).listRowInsets(EdgeInsets())
        }
        .tint(.primary)
        Section {
            if isETHVideoPromotionShown {
                Button {
                    openURL("https://apps.apple.com/app/id6458144304".toURL()!)
                } label: {
                    Label {
                        Text("CHECK_OUT_ETH_VIDEO")
                    } icon: {
                        Image(.appETHVideoIconRoundedForUserVersion)
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
                    Image(.appIconRoundedForUserVersion)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: imageSize,
                            height: imageSize
                        )
                }
            }
        } header: {
            Spacer(minLength: 10).listRowInsets(EdgeInsets())
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
