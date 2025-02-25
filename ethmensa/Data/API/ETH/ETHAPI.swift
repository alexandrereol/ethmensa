//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Foundation
import os.log

class ETHAPI: APIProtocol {
    static let shared = ETHAPI()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: ETHAPI.self)
    )

    private let host = "idapps.ethz.ch"
    private let endpoint = "https://idapps.ethz.ch/cookpit-pub-services/v1/weeklyrotas"

    private var apiValidAfterDate: Date? {
        Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: .now
            )
        )
    }
    private var apiValidBeforeDate: Date? {
        if let apiValidAfterDate,
           let startOfNextWeek = Calendar.current.date(
            byAdding: .weekOfYear,
            value: 1,
            to: apiValidAfterDate
           ) {
            Calendar.current.date(
                byAdding: .day,
                value: 7,
                to: startOfNextWeek
            )
        } else {
            nil
        }
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func get() async -> [Mensa] {
        let legacyMensas = await ETHAPILegacy.shared.get()
        guard !legacyMensas.isEmpty else {
            logger.critical("get(): legacyMensas is empty")
            return []
        }
        let language = Bundle.main.preferredLocalizations.first == "de" ? "de" : "en"
        let acceptLanguage = Bundle.main.preferredLocalizations.first == "de" ? "de-DE;de;q=0.9" : "en-EN,en;q=0.9"
        guard let apiValidAfterDate,
              let apiValidBeforeDate,
              let mensaAnswer = await download(
                language: language,
                acceptLanguage: acceptLanguage,
                validAfter: DateFormatter.getETHIDApps.string(from: apiValidAfterDate),
                validBefore: DateFormatter.getETHIDApps.string(from: apiValidBeforeDate)
              ),
              let weeklyRotaArray = mensaAnswer.weeklyRotaArray?.filter(\.isValidToday) else {
            logger.critical("get(): Could not download ETH data")
            return []
        }
        var mensaArray: [Mensa] = []
        for weeklyRota in weeklyRotaArray {
            guard let dayOfWeekArray = weeklyRota.dayOfWeekArray else {
                continue
            }
            var parsedMealTimeArray: [MealTime] = []
            for weekDay in dayOfWeekArray {
                for openingHour in weekDay.openingHourArray ?? [] {
                    for mealTime in openingHour.mealTimeArray?.sorted() ?? [] {
                        guard let lineArray = mealTime.lineArray else {
                            continue
                        }
                        let parsedMealArray: [Meal] = lineArray.compactMap { menuLine in
                            mapMeal(fromETHMenuLine: menuLine)
                        }
                        guard !parsedMealArray.isEmpty else {
                            continue
                        }
                        parsedMealTimeArray.append(
                            .init(
                                weekdayCode: weekDay.dayOfWeekCode,
                                startDateComponents: .fromStringSeparatedByColon(
                                    string: mealTime.timeFrom ?? ""
                                ),
                                endDateComponents: .fromStringSeparatedByColon(
                                    string: mealTime.timeTo ?? ""
                                ),
                                type: mealTime.name,
                                meals: parsedMealArray
                            )
                        )
                    }
                }
            }
            guard let facilityID = weeklyRota.facilityID,
                  let legacyMensa = legacyMensas.first(where: { $0.facilityID == facilityID }) else {
                logger.critical("get(): Could not get legacyMensa for facilityID \(weeklyRota.facilityID ?? -1)")
                continue
            }
            mensaArray.append(
                .init(
                    provider: .eth,
                    facilityID: facilityID,
                    name: legacyMensa.name,
                    location: legacyMensa.location,
                    webURL: legacyMensa.webURL,
                    imageURL: legacyMensa.imageURL,
                    mealTimes: parsedMealTimeArray
                )
            )
        }
        for legacyMensa in legacyMensas where !mensaArray.contains(legacyMensa) {
            mensaArray.append(legacyMensa)
        }
        return mensaArray
    }

    private func download(
        language: String,
        acceptLanguage: String,
        validAfter: String,
        validBefore: String
    ) async -> ETHMensaAnswer? {
        let params = [
            ("client-id", "ethz-wcms"),
            ("lang", language),
            ("rs-first", "0"),
            ("rs-size", "50"),
            ("valid-after", validAfter),
            ("valid-before", validBefore)
        ].map { "\($0)=\($1)" }.joined(separator: "&")
        guard let url = "\(self.endpoint)?\(params)".toURL() else {
            logger.critical("download(): Could not create URL from endpoint")
            return nil
        }
        let result = await API.shared.perform(
            url,
            host: host,
            headers: [
                "Accept": "application/json",
                "Accept-Language": acceptLanguage
            ],
            resultType: ETHMensaAnswer.self
        )
        switch result {
        case .success(let mensa):
            return mensa
        case .failure(let error):
            logger.critical("download(): \(error)")
            return nil
        }
    }

    private func mapMeal(fromETHMenuLine menuLine: ETHLineArray) -> Meal? {
        guard let meal = menuLine.meal else {
            logger.info("mapMeal(): meal data is nil for menuLine \(menuLine.name ?? "unknown")")
            return nil
        }
        let mealTitle = menuLine.name ?? String(localized: "MENU")
        let mealName = meal.name
        let mealDescription = meal.description?
            .replacingOccurrences(of: "|\n", with: "| ")
            .replacingOccurrences(of: "\n", with: " | ")
        let mealImageURL: URL? = if let imageURL = meal.imageURL {
            imageURL.appending("?client-id=ethz-wcms").toURL()
        } else {
            nil
        }
        let mealPrice = Price(
            student: meal.mealPriceArray?.first?.price,
            staff: meal.mealPriceArray?.second?.price,
            extern: meal.mealPriceArray?.third?.price
        )
        let mealType: [MealType]? = meal.mealClassArray?.compactMap(\.desc).compactMap {
            MealType.fromETHString($0)
        }
        let meatType: [MeatType]? = meal.meatTypeArray?.compactMap(\.desc).compactMap {
            MeatType.fromETHString($0)
        }
        let allergen: [Allergen]? = meal.allergenArray?.compactMap(\.desc).compactMap {
            Allergen.fromETHString($0)
        }
        return .init(
            title: mealTitle,
            name: mealName,
            description: mealDescription,
            imageURL: mealImageURL,
            price: mealPrice,
            mealType: mealType,
            meatType: meatType,
            allergen: allergen
        )
    }
}
