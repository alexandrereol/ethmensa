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

#if canImport(SafariServices)
import SafariServices
import SwiftUI

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
