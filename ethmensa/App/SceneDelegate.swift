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

import CoreSpotlight
import os.log
import UIKit
import UserNotifications

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: SceneDelegate.self)
    )

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let shortcutItem = connectionOptions.shortcutItem {
            logger.info("Shortcut item: \(shortcutItem.type)")
            _ = handleShortcutItem(shortcutItem)
        }
    }

    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        logger.info("Shortcut item: \(shortcutItem.type)")
        let actionSucceeded = handleShortcutItem(shortcutItem)
        completionHandler(actionSucceeded)
    }

    func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        switch shortcutItem.type {
        case .appshortcutCurrentlyOpen:
            SettingsManager.shared.mensaShowType = .open
            return true
        case .appshortcutZentrum:
            SettingsManager.shared.mensaLocationType = .zentrum
            return true
        case .appshortcutHongg:
            SettingsManager.shared.mensaLocationType = .hongg
            return true
        case .appshortcutIrchel:
            SettingsManager.shared.mensaLocationType = .irchel
            return true
        default:
            return false
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        Task {
#if !APPCLIP
            await SettingsManager.shared.osPermissionsResetIfNeeded()
#endif
            await MensaDataManager.shared.reloadUnfilteredMensaList()
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        UIApplication.shared.shortcutItems = [
            .init(
                type: .appshortcutCurrentlyOpen,
                localizedTitle: .init(localized: "CURRENTLY_OPEN"),
                localizedSubtitle: nil,
                icon: .init(systemImageName: "door.left.hand.open")
            ),
            .init(
                type: .appshortcutZentrum,
                localizedTitle: .init(localized: "ZENTRUM"),
                localizedSubtitle: nil,
                icon: .init(systemImageName: "building.2")
            ),
            .init(
                type: .appshortcutHongg,
                localizedTitle: .init(localized: "HONGGERBERG"),
                localizedSubtitle: nil,
                icon: .init(systemImageName: "atom")
            ),
            .init(
                type: .appshortcutIrchel,
                localizedTitle: .init(localized: "IRCHEL"),
                localizedSubtitle: nil,
                icon: .init(systemImageName: "graduationcap")
            )
        ]
#if !os(visionOS) && !APPCLIP
        if #available(iOS 18.0, *),
           let unfilteredMenaList = MensaDataManager.shared.unfilteredMenaList,
           !unfilteredMenaList.isEmpty {
            Task {
                do {
                    try await CSSearchableIndex.default().deleteAppEntities(ofType: MensaEntity.self)
                    try await CSSearchableIndex.default().indexAppEntities(
                        unfilteredMenaList.map { mensa in
                            MensaEntity(id: mensa.id, name: mensa.name)
                        },
                        priority: 10 // For future use
                    )
                    logger.info("\(#function): Indexed \(unfilteredMenaList.count) mensas")
                } catch {
                    logger.error("\(#function): Could not index app entities: \(error)")
                }
            }
        }
#endif
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        SettingsManager.shared.synchronize()
    }
}
