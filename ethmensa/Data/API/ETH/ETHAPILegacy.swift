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

import Foundation
import os.log

class ETHAPILegacy: APIProtocol {
    static let shared = ETHAPILegacy()
    private let logger = Logger(
        subsystem: Bundle.main.safeIdentifier,
        category: String(describing: ETHAPILegacy.self)
    )

    private let host = "idapps.ethz.ch"
    private let endpoint = "https://glyph.ethz.ch/eth-ws"

    func get() async -> [Mensa] {
        let language = Bundle.main.preferredLocalizations.first == "de" ? "de" : "en"
        let acceptLanguage = Bundle.main.preferredLocalizations.first == "de" ? "de-DE;de;q=0.9" : "en-EN,en;q=0.9"
        guard let mensaAnswer = await download(language: language, acceptLanguage: acceptLanguage) else {
            logger.critical(
                "\(#function): mensaAnswer from download(language: \(language), acceptLanguage: \(acceptLanguage)) is nil"
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
            logger.critical("\(#function): Could not create URL from endpoint")
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
            logger.critical("\(#function): \(error)")
            return nil
        }
    }
}
