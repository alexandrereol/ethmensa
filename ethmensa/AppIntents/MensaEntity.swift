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
import UIKit

struct MensaEntity: AppEntity, Identifiable {

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "MENSA")
    static var defaultQuery = MensaIntentsQuery()

    var id: String

    @Property(title: "MENSA_NAME")
    var name: String

    private static let appIconPngData: Data? = UIImage.appIconRoundedForUserVersion.pngData()

    var displayRepresentation: DisplayRepresentation {
        if let uiImagePngData = Self.appIconPngData {
            .init(
                title: "\(name)",
                image: DisplayRepresentation.Image(
                    data: uiImagePngData
                )
            )
        } else {
            .init(
                title: "\(name)"
            )
        }
    }

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

struct MensaIntentsQuery: EntityQuery, EnumerableEntityQuery {
    func allEntities() async throws -> [MensaEntity] {
        await MensaDataManager.shared.reloadUnfilteredMensaList()
        return MensaDataManager.shared.unfilteredMenaList?.map { mensa in
            MensaEntity(
                id: mensa.id,
                name: mensa.name
            )
        } ?? []
    }

    func entities(for identifiers: [String]) async throws -> [MensaEntity] {
        await MensaDataManager.shared.reloadUnfilteredMensaList()
        return MensaDataManager.shared.unfilteredMenaList?.filter { mensa in
            identifiers.contains(where: { $0 == mensa.id })
        }.map { mensa in
            MensaEntity(
                id: mensa.id,
                name: mensa.name
            )
        } ?? []
    }

    func suggestedEntities() async throws -> [MensaEntity] {
        await MensaDataManager.shared.reloadUnfilteredMensaList()
        return MensaDataManager.shared.unfilteredMenaList?.map { mensa in
            MensaEntity(
                id: mensa.id,
                name: mensa.name
            )
        } ?? []
    }
}
