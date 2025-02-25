//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Foundation
import os.log

class ETHAPILegacy: APIProtocol {
    static let shared = ETHAPILegacy()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: ETHAPILegacy.self)
    )

    private let host = "idapps.ethz.ch"
    private let endpoint = "https://glyph.ethz.ch/eth-ws"

    func get() async -> [Mensa] {
        let language = Bundle.main.preferredLocalizations.first == "de" ? "de" : "en"
        let acceptLanguage = Bundle.main.preferredLocalizations.first == "de" ? "de-DE;de;q=0.9" : "en-EN,en;q=0.9"
        guard let mensaAnswer = await download(language: language, acceptLanguage: acceptLanguage) else {
            logger.critical(
                "get(): mensaAnswer from download(language: \(language), acceptLanguage: \(acceptLanguage)) is nil"
            )
            return []
        }
        return mensaAnswer.map { legacyMensa in
            Mensa(
                provider: .eth,
                facilityID: legacyMensa.mensaId,
                name: legacyMensa.name,
                location: legacyMensa.address,
                webURL: legacyMensa.web?.toURL(),
                imageURL: legacyMensa.imageUrl?.toURL(),
                mealTimes: []
            )
        }
    }

    private func download(language: String, acceptLanguage: String) async -> [ETHMensaAnswerLegacy]? {
        guard let url = "\(endpoint)/mensas/detail?lang=\(language)".toURL() else {
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
            resultType: [ETHMensaAnswerLegacy].self
        )
        switch result {
        case .success(let mensa):
            return mensa
        case .failure(let error):
            logger.critical("download(): \(error)")
            return nil
        }
    }
}
