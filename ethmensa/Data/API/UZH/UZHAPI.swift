//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import os.log
import Foundation

class UZHAPI: APIProtocol {
    static let shared = UZHAPI()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: UZHAPI.self)
    )

    private let host = "iduzhnowweb.uzh.ch"
    private let endpoint = "https://iduzhnowweb.uzh.ch/v3/mensa/overviewfordays"

    func get() async -> [Mensa] {
        guard let uzhAnswer = await download(),
              let uzhDays = uzhAnswer.days else {
            logger.critical("get(): Could not download UZH data")
            return []
        }
        let uniqueIds = getUniqueIds(fromUZHDays: uzhDays)
        return mapMensas(fromIds: uniqueIds, usingUzhDays: uzhDays)
    }

    private func download() async -> UZHMensaAnswer? {
        guard let url = self.endpoint.toURL() else {
            logger.critical("download(): Could not create URL from endpoint")
            return nil
        }
        let result = await API.shared.perform(
            url,
            host: host,
            resultType: UZHMensaAnswer.self
        )
        switch result {
        case .success(let mensa):
            return mensa
        case .failure(let error):
            logger.critical("download(): \(error)")
            return nil
        }
    }

    private func getUniqueIds(fromUZHDays uzhDays: [UZHDay]) -> [Int] {
        uzhDays.compactMap { uzhDay -> [Int]? in
            guard let mensaArray = uzhDay.mensa else {
                logger.critical("getUniqueIds(): Could not get mensa array from UZH day (\(uzhDay.dayDate ?? "nil"))")
                return nil
            }
            return mensaArray.compactMap(\.mensaId)
        }.flatMap { $0 }.filter { $0 < 100 }.unique // ETH Mensas have id >= 100
    }

    private func mapMensas(fromIds ids: [Int], usingUzhDays uzhDays: [UZHDay]) -> [Mensa] {
        ids.compactMap { id -> Mensa? in
            mapMensa(fromId: id, usingUzhDays: uzhDays)
        }
    }

    private func mapMensa(fromId id: Int, usingUzhDays uzhDays: [UZHDay]) -> Mensa? {
        let filteredUZHDay = uzhDays.compactMap { uzhDay -> UZHDay? in
            guard let mensaArray = uzhDay.mensa else {
                logger.critical("mapMensa(): Could not get mensa (\(id)) from UZH day (\(uzhDay.dayDate ?? "nil"))")
                return nil
            }
            let mensas = mensaArray.filter { mensa in
                mensa.mensaId == id
            }
            return .init(
                dayDate: uzhDay.dayDate,
                mensa: mensas
            )
        }
        guard let mensaOnFirstUZHDay = filteredUZHDay.first?.mensa?.first,
              let mensaId = mensaOnFirstUZHDay.mensaId,
              let name = mensaOnFirstUZHDay.name else {
            logger.critical("mapMensa(): Could not get mensa (\(id)) data from UZH day")
            return nil
        }
        let timeString = mensaOnFirstUZHDay.open?.first?.text?
            .replacingOccurrences(of: " – ", with: "–")
            .replacingOccurrences(of: ".", with: ":")
        let timeFrom = timeString?.components(separatedBy: "–").first
        let timeTo = timeString?.components(separatedBy: "–").second
        let mealStartDateComponents = DateComponents.fromStringSeparatedByColon(string: timeFrom ?? "")
        let mealEndDateComponents = DateComponents.fromStringSeparatedByColon(string: timeTo ?? "")
        let mealTimes = filteredUZHDay.enumerated().compactMap { index, uzhDay -> MealTime? in
            mapToMealTime(
                fromUzhDay: uzhDay,
                weekdayCode: (index + 1),
                mealStartDateComponents: mealStartDateComponents,
                mealEndDateComponents: mealEndDateComponents
            )
        }
        return .init(
            provider: .uzh,
            facilityID: mensaId,
            name: name,
            location: mensaOnFirstUZHDay.address?
                .replacingOccurrences(of: ",", with: ""),
            webURL: nil,
            imageURL: mensaOnFirstUZHDay.imageUrl?.toURL(),
            mealTimes: mealTimes
        )
    }

    private func mapToMealTime(
        fromUzhDay uzhDay: UZHDay,
        weekdayCode: Int,
        mealStartDateComponents: DateComponents?,
        mealEndDateComponents: DateComponents?
    ) -> MealTime? {
        guard let mensa = uzhDay.mensa?.first,
              let menuTime = mensa.menuTime,
              let menu = mensa.menus else {
            logger.critical("mapToMealTime(): Could not get menu data from UZH day (\(uzhDay.dayDate ?? "unknown"))")
            return nil
        }
        let meals = menu.enumerated().compactMap { index, uzhMenu -> Meal? in
            mapToMeal(fromUzhMenu: uzhMenu, id: index)
        }
        if meals.isEmpty {
            logger.info("mapToMealTime(): No meals found for UZH day (\(uzhDay.dayDate ?? "unknown"))")
            return nil
        } else {
            return .init(
                weekdayCode: weekdayCode,
                startDateComponents: mealStartDateComponents,
                endDateComponents: mealEndDateComponents,
                type: menuTime,
                meals: meals
            )
        }
    }

    private func mapToMeal(fromUzhMenu uzhMenu: UZHMenu, id: Int) -> Meal? {
        guard let menuTitle = uzhMenu.menuTitle,
              let menuText = uzhMenu.menuText else {
            logger.critical("mapToMeal(): Could not get menu data from UZH menu (\(id))")
            return nil
        }
        let price = Price(
            student: uzhMenu.priceStudent,
            staff: uzhMenu.priceEmployee,
            extern: uzhMenu.priceExtern
        )
        let allergen = uzhMenu.ingredients?.allergene?.compactMap { string in
            Allergen.fromUZHString(string)
        }
        let mealType = uzhMenu.menuTypes?.compactMap { string in
            MealType.fromUZHString(string)
        }
        return .init(
            title: menuTitle,
            name: nil,
            description: menuText,
            imageURL: nil,
            price: price,
            mealType: mealType,
            allergen: allergen
        )
    }
}
