//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

#if canImport(SafariServices)
import SwiftUI
import SafariServices

struct SafariWebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(
        context: Context
    ) -> SFSafariViewController {
        let svc = SFSafariViewController(url: url)
#if !os(visionOS)
        svc.preferredControlTintColor = .tintColor
#endif
        return svc
    }

    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: Context
    ) { }
}

#Preview {
    SafariWebView(
        url: "https://ethmensa.ch".toURL()!
    )
}
#endif
