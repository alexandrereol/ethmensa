//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct VersionIncompatibleModifier: ViewModifier {

    @State var versionIncompatible = false

    private var host: String
    private var tintColor: Color
    private var appIcon: UIImage
    private var mainButtonAction: (() -> Void)?
    private var detailButtonAction: (() -> Void)?

    init(
        host: String,
        tintColor: Color,
        appIcon: UIImage,
        mainButtonAction: (() -> Void)? = nil,
        detailButtonAction: (() -> Void)? = nil
    ) {
        self.host = host
        self.tintColor = tintColor
        self.appIcon = appIcon
        self.mainButtonAction = mainButtonAction
        self.detailButtonAction = detailButtonAction
    }

    func body(content: Content) -> some View {
        content
            .onAppear {
                Task {
                    let versionIncompatible = await VersionIncompatible.fetchVersionCompatible(
                        host: host
                    )
                    await MainActor.run {
                        self.versionIncompatible = versionIncompatible
                    }
                }
            }
            .fullScreenCover(isPresented: $versionIncompatible) {
                ModalViewUI(
                    viewModel: .update(
                        mainButtonAction: mainButtonAction,
                        detailButtonAction: detailButtonAction
                    )
                )
            }
    }
}

extension View {
    func versionIncompatibleIfNeeded(
        host: String,
        tintColor: Color,
        appIcon: UIImage,
        mainButtonAction: (() -> Void)? = nil,
        detailButtonAction: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            VersionIncompatibleModifier(
                host: host,
                tintColor: tintColor,
                appIcon: appIcon,
                mainButtonAction: mainButtonAction,
                detailButtonAction: detailButtonAction
            )
        )
    }
}
