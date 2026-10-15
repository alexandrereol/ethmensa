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

// The visionOS and Mac Catalyst SDKs (27.0) have no ArrangementView and no reserved regions.
#if os(iOS) && !targetEnvironment(macCatalyst)
import SwiftUI

extension View {

    /// Keeps a pane's content beside the fold of a foldable iPhone when the fold runs through the pane.
    ///
    /// Folded like a book, `ArrangementView` splits the inner display at the fold. Flat, it splits the
    /// safe area in the middle, left of the status bar, so the fold runs through the trailing pane.
    /// Padding the content past the fold, inactive while flat, keeps the pane's controls in one half of
    /// the display, where they also are when folded. A fold that doesn't cross the view, and devices
    /// without one, leave the view as it is.
    ///
    /// Use it on each pane of an `ArrangementView`.
    @available(iOS 27.1, *)
    func foldClearance() -> some View {
        modifier(FoldClearance())
    }

}

/// Pads a view's content past a vertical fold that runs through it, see `View.foldClearance()`.
@available(iOS 27.1, *)
private struct FoldClearance: ViewModifier {

    @State private var insets = FoldInsets()

    func body(content: Content) -> some View {
        content
            .padding(.leading, insets.leading)
            .padding(.trailing, insets.trailing)
            .onGeometryChange(for: FoldInsets.self) { proxy in
                FoldInsets(proxy)
            } action: { newValue in
                insets = newValue
            }
    }

}

/// How far a fold that runs from top to bottom reaches into a view from its leading or trailing edge.
@available(iOS 27.1, *)
private struct FoldInsets: Equatable, Sendable {

    /// A side narrower than this, the narrowest iPhone width, is too narrow for the content.
    private static let minimumSideWidth: CGFloat = 320

    var leading: CGFloat = 0
    var trailing: CGFloat = 0

    init() { }

    init(_ proxy: GeometryProxy) {
        let width = proxy.size.width
        // Inactive ones too: flat, the fold keeps its frame, which includes the clearance for controls.
        guard let fold = proxy.reservedRegions(kind: .division, options: .includeInactive).first(where: {
            $0.frame.height > $0.frame.width && $0.frame.maxX > 0 && $0.frame.minX < width
        }) else {
            return
        }
        // The content keeps to the larger side. Flat, it ignores a fold that leaves no side wide enough for it.
        let leadingSide = max(fold.frame.minX, 0)
        let trailingSide = max(width - fold.frame.maxX, 0)
        if !fold.isActive, max(leadingSide, trailingSide) < Self.minimumSideWidth {
            return
        }
        if trailingSide >= leadingSide {
            leading = width - trailingSide
        } else {
            trailing = width - leadingSide
        }
    }

}
#endif
