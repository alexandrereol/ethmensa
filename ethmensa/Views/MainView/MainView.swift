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

import AppIntents
import SwiftUI

struct MainView: View {

    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var mensaDataManager: MensaDataManager
    @EnvironmentObject var settingsManager: SettingsManager

    /// Where the filter chips end, so the empty state stays below them.
    @State private var filterChipsFrame = FilterChipsFrame()

    fileprivate static let coordinateSpaceName = "MainView"

    private enum ViewState {
        case loading
        case loadedButEmpty
        case loadedWithContent
    }

    private func viewState(for mensaList: [Mensa]?) -> ViewState {
        if let mensaList {
            if mensaList.isEmpty {
                .loadedButEmpty
            } else {
                .loadedWithContent
            }
        } else {
            .loading
        }
    }

    private var listRowSpacing: CGFloat {
        let cond1 = settingsManager.mensaCellType == .minimal
        let cond2 = UIDevice.current.userInterfaceIdiom == .pad
        return cond1 && cond2 ? 0 : 15
    }

    var body: some View {
        // The filtered list is derived on access, so it is computed only once per render.
        let mensaList = mensaDataManager.mensaList(for: navigationManager)
        let viewState = self.viewState(for: mensaList)
        ZStack {
            List(selection: $navigationManager.selectedMensa) {
                Section {
                    if viewState == .loadedWithContent {
                        ForEach(mensaList ?? []) { mensa in
                            MainMensaView(mensa: mensa)
                                .mensaEntityIdentifier(mensa)
                        }
                    } else if viewState == .loading {
                        ForEach(Array(repeating: Mensa.example, count: 10)) { mensa in
                            MainMensaView(mensa: mensa, isLoading: true)
                        }
                        .onAppear {
                            // The list may also be loading while the campuses of the mensas are determined.
                            guard mensaDataManager.unfilteredMenaList == nil else {
                                return
                            }
                            Task {
                                await mensaDataManager.reloadUnfilteredMensaList()
                            }
                        }
                    }
                } header: {
                    // A header instead of a row, as inserting or removing a row makes the list jump
                    // and an empty row would leave a gap.
                    FilterView()
                        .textCase(nil)
                        // Section headers are inset like the cells' content and ignore `listRowInsets`,
                        // so the chips are pulled out to align with the edges of the cells.
                        .padding(.horizontal, -16)
                        // Brings the chips a little closer to the title.
                        .padding(.top, -6)
                        // Gives the chips a little room above the first cell, without leaving a gap without filters.
                        .padding(.bottom, MensaFilter.isAnyActive(in: navigationManager) ? 6 : 0)
                        .onGeometryChange(for: CGFloat.self) { proxy in
                            proxy.frame(in: .named(Self.coordinateSpaceName)).maxY
                        } action: { [filterChipsFrame] newValue in
                            filterChipsFrame.bottom = newValue
                        }
                }
            }
            .environment(\.defaultMinListHeaderHeight, 0)
            .redacted(reason: viewState == .loading ? .placeholder : [])
            .disabled(viewState == .loading)
            .scrollDisabled(viewState == .loading)
            .listRowSpacing(listRowSpacing)
            .refreshable {
                Task {
                    await mensaDataManager.reloadUnfilteredMensaList()
                }
            }
            if viewState == .loadedButEmpty {
                BelowFilterChips(chipsFrame: filterChipsFrame, content: noResultsView)
            }
        }
        .coordinateSpace(name: Self.coordinateSpaceName)
        .environmentObject(navigationManager)
        .environmentObject(mensaDataManager)
#if !os(visionOS)
        .navigationTitle(Bundle.main.displayName)
#endif
        .searchable(
            text: $navigationManager.searchTerm,
            prompt: "SEARCH_MENSAS"
        )
        .toolbar {
            MainViewToolbar(navigationManager: navigationManager)
        }
    }

    private var noResultsView: some View {
        CustomContentUnavailableView(
            label: .init(localized: "NO_RESULTS"),
            systemImageName: "sparkle.magnifyingglass",
            description: .init(localized: "NO_RESULTS_FOR_SELECTED_FILTERS."),
            actions: {
                Button {
                    navigationManager.resetFiltersAndSearch()
                } label: {
                    Text("RESET_FILTERS_AND_SEARCH")
                        .padding(2)
                }
                .resetButtonStyle()
            }
        )
    }
}

#Preview("Sample Data") {
    NavigationStack {
        MainView()
            .environmentObject(NavigationManager.example)
            .environmentObject(MensaDataManager.shared)
            .environmentObject(SettingsManager.shared)
    }
}

#Preview("Live Data") {
    AppView()
        .environmentObject(NavigationManager())
        .environmentObject(MensaDataManager.shared)
        .environmentObject(NetworkManager.shared)
        .environmentObject(SettingsManager.shared)
}

/// Where the filter chips in the list's header end, in the coordinate space of `MainView`.
///
/// A reference that `MainView` doesn't observe: the header moves on every frame the list scrolls, and only
/// the empty state, which observes it, should update then, not the whole list.
private final class FilterChipsFrame: ObservableObject {
    @Published var bottom: CGFloat = 0
}

/// Keeps the empty state below the filter chips, so it never covers them, even at large text sizes.
/// Centred as before while that leaves the chips clear; scrolling, from below the chips, once it is
/// taller than the space left.
private struct BelowFilterChips<Content: View>: View {

    @ObservedObject var chipsFrame: FilterChipsFrame
    let content: Content

    /// The top edge of this view, in the coordinate space of `MainView`.
    @State private var top: CGFloat = 0

    var body: some View {
        let clearance = max(chipsFrame.bottom - top, 0)
        ViewThatFits(in: .vertical) {
            CenteredBelowLayout(minTop: clearance) {
                content
            }
            ScrollView {
                content
            }
            .padding(.top, clearance)
        }
        .onGeometryChange(for: CGFloat.self) { proxy in
            proxy.frame(in: .named(MainView.coordinateSpaceName)).minY
        } action: { newValue in
            top = newValue
        }
    }
}

/// Centres its content vertically, but never higher than `minTop` from its top edge.
/// Its ideal height is the content's plus `minTop`, so a `ViewThatFits` can fall back once it doesn't fit.
private struct CenteredBelowLayout: Layout {

    var minTop: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let content = subviews.first?.sizeThatFits(ProposedViewSize(width: proposal.width, height: nil)) ?? .zero
        return CGSize(width: proposal.width ?? content.width, height: proposal.height ?? content.height + minTop)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard let content = subviews.first else {
            return
        }
        let height = content.sizeThatFits(ProposedViewSize(width: bounds.width, height: nil)).height
        let top = max(bounds.midY - height / 2, bounds.minY + minTop)
        content.place(
            at: CGPoint(x: bounds.midX, y: top),
            anchor: .top,
            proposal: ProposedViewSize(width: bounds.width, height: height)
        )
    }
}

private extension View {

    /// Tells Siri and Apple Intelligence which Mensa a row shows, on iOS 27 and later.
    /// `MensaEntity` is not part of the App Clip and visionOS targets.
    @ViewBuilder
    func mensaEntityIdentifier(_ mensa: Mensa) -> some View {
#if !APPCLIP && !os(visionOS)
        if #available(iOS 27.0, *) {
            self
                .appEntityIdentifier(EntityIdentifier(for: MensaEntity.self, identifier: mensa.id))
        } else {
            self
        }
#else
        self
#endif
    }

    /// Styles the reset button of the empty state prominently.
    /// On iOS 26 and later it uses Liquid Glass. The glass styles are not
    /// available on visionOS, whose bordered buttons are already glass.
    @ViewBuilder
    func resetButtonStyle() -> some View {
#if !os(visionOS)
        if #available(iOS 26.0, *) {
            self
                .buttonStyle(.glassProminent)
        } else {
            legacyResetButtonStyle()
        }
#else
        legacyResetButtonStyle()
#endif
    }

    private func legacyResetButtonStyle() -> some View {
        self
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
    }
}
