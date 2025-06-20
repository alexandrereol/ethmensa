//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import AppIntents
import UIKit

struct MensaEntity: AppEntity, Identifiable {

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "MENSA")
    static var defaultQuery = MensaIntentsQuery()

    var id: String

    @Property(title: "MENSA_NAME")
    var name: String

    var displayRepresentation: DisplayRepresentation {
        if let uiImagePngData = UIImage(
            resource: .appIconRoundedForUserVersion
        ).pngData() {
            .init(
                title: "\(name)",
                // In the future return image of the Mensa itself, probably from `URLImage` cache
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
