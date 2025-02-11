//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import WatchKit

class AppDelegate: NSObject, WKApplicationDelegate {
    func applicationDidFinishLaunching() {
        NetworkManager.shared.startNwMonitoring()
        URLCache.shared.memoryCapacity = 10_000_000 // 10MB
        URLCache.shared.diskCapacity = 50_000_000 // 50MB
        SettingsManager.shared.launchAndMigrate()
    }
}
