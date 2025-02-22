//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI
import MapKit

struct MapHeaderView: View {

    @EnvironmentObject var navigationManager: NavigationManager

    @StateObject var viewModel = MapHeaderViewModel()

    private var openingTimes: String {
        if let selectedMensa = navigationManager.selectedMensa {
            viewModel.getOpeningTimesString(
                mensa: selectedMensa,
                weekday: navigationManager.selectedWeekdayCode
            )
        } else {
            // Should never occur
            ""
        }
    }

    var body: some View {
        if let selectedMensa = navigationManager.selectedMensa {
            HStack(spacing: 25) {
                Group {
                    if let mapCenter = viewModel.mapCenter {
                        Map(
                            coordinateRegion: .constant(mapCenter),
                            interactionModes: []
                        )
                    } else {
                        Rectangle()
                            .foregroundStyle(.gray)
                    }
                }
                .cornerRadius(15)
                .frame(width: 100, height: 100)
                .onTapGesture {
                    viewModel.handleTap(mensa: selectedMensa)
                }
                .mapItemDetailSheetIfPossibleModifier(
                    isPresented: $viewModel.mapSheetShown,
                    item: viewModel.mapItem,
                    displaysMap: true
                )
                VStack(alignment: .leading, spacing: 10) {
                    if let location = selectedMensa.location {
                        Text(location)
                            .lineLimit(3)
                            .minimumScaleFactor(0.75)
                    }
                    if !openingTimes.isEmpty {
                        Text(openingTimes)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadMap(forMensa: selectedMensa)
                }
            }
        }
    }
}

private struct MapItemDetailSheetIfPossibleModifier: ViewModifier {

    var isPresented: Binding<Bool>
    var item: MKMapItem?
    var displaysMap: Bool

    func body(content: Content) -> some View {
        Group {
            if #available(iOS 18.0, visionOS 2.0, *) {
                content.mapItemDetailSheet(
                    isPresented: isPresented,
                    item: item,
                    displaysMap: displaysMap
                )
            } else {
                content
            }
        }
    }
}

private extension View {
    @ViewBuilder
    func mapItemDetailSheetIfPossibleModifier(
        isPresented: Binding<Bool>,
        item: MKMapItem?,
        displaysMap: Bool
    ) -> some View {
        self.modifier(
            MapItemDetailSheetIfPossibleModifier(
                isPresented: isPresented,
                item: item,
                displaysMap: true
            )
        )
    }
}

#Preview("Empty") {
    List {
        MapHeaderView()
    }
    .environmentObject(NavigationManager.example)
}
