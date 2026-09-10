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
import URLImage

/// Shows a single remote image fullscreen on a black background.
///
/// The image can be pinched to zoom, dragged to pan while zoomed and
/// double-tapped to toggle between the fitted and a 3x zoomed state.
/// Intended to be presented with `fullScreenCover`.
struct FullscreenImageView: View {

    let url: URL

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                URLImage(url: url) {
                    ProgressView()
                        .tint(.white)
                } inProgress: { _ in
                    ProgressView()
                        .tint(.white)
                } failure: { _, _ in
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.white.opacity(0.6))
                } content: { image in
                    ZoomableImage(image: image)
                }
            }
            .ignoresSafeArea()
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("CLOSE", systemImage: "xmark")
                    }
                    .keyboardShortcut(.escape, modifiers: [])
                }
            }
        }
    }
}

/// A single image with pinch-to-zoom, drag-to-pan and double-tap-to-zoom.
private struct ZoomableImage: View {

    let image: Image

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        GeometryReader { geo in
            image
                .resizable().scaledToFit()
                .frame(width: geo.size.width, height: geo.size.height)
                .scaleEffect(scale)
                .offset(offset)
                .modifier(
                    MagnifyGestureModifier { magnification, anchor in
                        let newScale = max(1, lastScale * magnification)
                        let ratio = newScale / lastScale
                        let anchorOffset = CGSize(
                            width: (anchor.x - 0.5) * geo.size.width,
                            height: (anchor.y - 0.5) * geo.size.height
                        )
                        withAnimation(.easeOut(duration: 0.1)) {
                            scale = newScale
                            offset = CGSize(
                                width: anchorOffset.width * (1 - ratio) + lastOffset.width * ratio,
                                height: anchorOffset.height * (1 - ratio) + lastOffset.height * ratio
                            )
                        }
                    } onEnded: {
                        lastScale = scale
                        lastOffset = offset
                        if scale <= 1 {
                            withAnimation(.spring()) {
                                offset = .zero
                                lastOffset = .zero
                            }
                        }
                    }
                )
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation(.easeOut(duration: 0.1)) {
                                offset = CGSize(
                                    width: lastOffset.width + value.translation.width,
                                    height: lastOffset.height + value.translation.height
                                )
                            }
                        }
                        .onEnded { _ in
                            lastOffset = offset
                        },
                    including: scale > 1 ? .all : .subviews
                )
                .onTapGesture(count: 2) {
                    withAnimation(.spring()) {
                        if scale > 1 {
                            resetZoom()
                        } else {
                            scale = 3
                            lastScale = 3
                            offset = .zero
                            lastOffset = .zero
                        }
                    }
                }
        }
        .clipped()
    }

    private func resetZoom() {
        scale = 1
        lastScale = 1
        offset = .zero
        lastOffset = .zero
    }
}

/// Attaches a pinch gesture that reports the magnification and the anchor point of the pinch.
///
/// Uses `MagnifyGesture` where available so zooming happens around the fingers.
/// On iOS 16 it falls back to `MagnificationGesture`, which zooms around the centre.
private struct MagnifyGestureModifier: ViewModifier {

    let onChanged: (_ magnification: CGFloat, _ anchor: UnitPoint) -> Void
    let onEnded: () -> Void

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.gesture(
                MagnifyGesture()
                    .onChanged { value in
                        onChanged(value.magnification, value.startAnchor)
                    }
                    .onEnded { _ in
                        onEnded()
                    }
            )
        } else {
            content.gesture(
                MagnificationGesture()
                    .onChanged { value in
                        onChanged(value, .center)
                    }
                    .onEnded { _ in
                        onEnded()
                    }
            )
        }
    }
}

#Preview {
    if let url = Meal.example.imageURL {
        FullscreenImageView(url: url)
    }
}
