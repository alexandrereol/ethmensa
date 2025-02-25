//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Combine
import Foundation
import MapKit

class MapHeaderViewModel: ObservableObject {

    @Published var mapCenter: MKCoordinateRegion?
    @Published var mapItem: MKMapItem?
    @Published var mapSheetShown = false

    private var subscribers: Set<AnyCancellable> = []

    init() {
        NavigationManager.shared.$selectedMensa
            .compactMap { $0 }
            .sink { mensa in
                Task {
                    await self.loadMap(forMensa: mensa)
                }
            }
            .store(in: &subscribers)
    }

    func handleTap(mensa: Mensa) {
        if #available(iOS 18.0, visionOS 2.0, *) {
            mapSheetShown = true
        } else {
            openInMaps()
        }
    }

    func loadMap(forMensa mensa: Mensa) async {
        guard let result = await mensa.getCoordinates() else {
            return
        }
        await MainActor.run {
            mapCenter = MKCoordinateRegion(
                center: result.coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
        }
        await setMkMapItem(mensa: mensa)
    }

    private func setMkMapItem(mensa: Mensa) async {
        guard let mapCenter else {
            return
        }
        let lat = mapCenter.center.latitude
        let long = mapCenter.center.longitude
        let coordinateLocation = CLLocation(
            latitude: lat,
            longitude: long
        )
        let coordinateMapItem = MKMapItem(
            placemark: .init(
                coordinate: .init(
                    latitude: lat,
                    longitude: long
                )
            )
        )
        coordinateMapItem.name = mensa.name
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = [mensa.name, mensa.location]
            .compactMap { $0 }
            .joined(separator: " ")
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: ",", with: " ")
        searchRequest.region = mapCenter
        let search = MKLocalSearch(request: searchRequest)
        do {
            let response = try await search.start()
            await MainActor.run {
                mapItem = response.mapItems.first { mkMapItem in
                    if let mkMapItemLocation = mkMapItem.placemark.location {
                        mkMapItemLocation.distance(from: coordinateLocation) < 250
                    } else {
                        false
                    }
                } ?? coordinateMapItem
            }
        } catch {
            await MainActor.run {
                self.mapItem = coordinateMapItem
            }
        }
    }

    private func openInMaps() {
        guard let mapItem,
              let mapCenter else {
            return
        }
        let regionDistance: CLLocationDistance = 1000
        let coordinates = mapCenter.center
        let regionSpan = MKCoordinateRegion(
            center: coordinates,
            latitudinalMeters: regionDistance,
            longitudinalMeters: regionDistance
        )
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(
                mkCoordinate: regionSpan.center
            ),
            MKLaunchOptionsMapSpanKey: NSValue(
                mkCoordinateSpan: regionSpan.span
            )
        ]
        _ = mapItem.openInMaps(launchOptions: options)
    }

    func getOpeningTimesString(mensa: Mensa, weekday: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return mensa.mealTimes.filter { mealTime in
            mealTime.weekdayCode == weekday
        }.compactMap { mealTime in
            if let startDateComponents = mealTime.startDateComponents,
               let endDateComponents = mealTime.endDateComponents {
                var todayStartDateComponents = Calendar.current.dateComponents(
                    [.hour, .minute, .second, .day, .month, .year],
                    from: .now
                )
                var todayEndDateComponents = Calendar.current.dateComponents(
                    [.hour, .minute, .second, .day, .month, .year],
                    from: .now
                )
                todayStartDateComponents.hour = startDateComponents.hour
                todayStartDateComponents.minute = startDateComponents.minute
                todayEndDateComponents.hour = endDateComponents.hour
                todayEndDateComponents.minute = endDateComponents.minute
                guard let startDate = Calendar.current.date(from: todayStartDateComponents),
                      let endDate = Calendar.current.date(from: todayEndDateComponents) else {
                    return nil
                }
                return [
                    dateFormatter.string(from: startDate),
                    dateFormatter.string(from: endDate)
                ].joined(separator: "-")
            } else {
                return nil
            }
        }.joined(separator: ", ")
    }
}
