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

class ZFVAPI: APIProtocol {
    static let shared = ZFVAPI()

    private let logger = Logger(
        subsystem: Bundle.main.safeIdentifier,
        category: String(describing: ZFVAPI.self)
    )

    private let host = "api.zfv.ch"
    private let endpoint = "https://api.zfv.ch/graphql"
    // Without `take`, only the first 10 outlets are returned. 100 is the maximum.
    private let query = """
        query MensasQuery {
          outlets(take: 100) {
            externalId
            name
            location {
              address {
                addressLine1
                zipCode
                city
              }
            }
            calendar {
              week {
                daily {
                  date {
                    weekdayNumber
                  }
                  menuCategories {
                    category {
                      name
                      slug
                    }
                    menuItems {
                      ... on OutletMenuItemDish {
                        dish {
                          name(mode: SHORT)
                          description
                          media {
                            media {
                              url
                            }
                          }
                          allergens {
                            allergen {
                              externalId
                              name
                            }
                          }
                          isVegan
                          isVegetarian
                        }
                        category {
                          name
                        }
                        prices {
                          priceCategory {
                            externalId
                          }
                          amount
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        """

    /// The language the menus are requested in.
    private var locale: String {
        Bundle.main.preferredLocalizations.first ?? "de"
    }

    private let cache = APICache<[ZFVOutlet]>(name: "zfv_outlets")

    func get() async -> [Mensa] {
        async let infos = ZFVOutletInfo.load()
        let answer = await download()
        // A response with errors may be incomplete, so it neither replaces the cache nor the last complete download
        let downloadedOutlets = answer?.errors?.isEmpty == false ? nil : answer?.data?.outlets
        if let downloadedOutlets {
            cache.write(downloadedOutlets, language: locale)
        }
        // Falls back to the last download if it is from this week
        guard let outlets = downloadedOutlets ?? cache.read(language: locale) ?? answer?.data?.outlets else {
            logger.critical("\(#function): Could not download ZFV data")
            return []
        }
        return await ZFVConverter.convert(outlets: outlets, infos: infos)
    }

    func cached() async -> [Mensa]? {
        guard let outlets = cache.read(language: locale) else {
            return nil
        }
        return ZFVConverter.convert(outlets: outlets, infos: ZFVOutletInfo.cached())
    }

    private func download() async -> ZFVMensaAnswer? {
        guard let apiKey = Bundle.main.zfvAPIKey else {
            logger.critical("\(#function): Missing ZFV_API_KEY")
            return nil
        }
        guard let url = self.endpoint.toURL(),
              let body = try? JSONEncoder().encode(["query": query]) else {
            logger.critical("\(#function): Could not create request")
            return nil
        }
        let result = await API.shared.perform(
            url,
            host: host,
            headers: [
                "Content-Type": "application/json",
                "api-key": apiKey,
                "locale": locale
            ],
            body: body,
            resultType: ZFVMensaAnswer.self
        )
        switch result {
        case .success(let answer):
            if let errors = answer.errors, !errors.isEmpty {
                logger.error("\(#function): GraphQL errors: \(errors.compactMap(\.message))")
            }
            return answer
        case .failure(let error):
            logger.critical("\(#function): \(error)")
            return nil
        }
    }
}
