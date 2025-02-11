//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import os.log
import SwiftUI
import AVFoundation

class SoundSelectionViewModel: ObservableObject {
    let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: SoundSelectionViewModel.self)
    )

    private var player: AVAudioPlayer?

    func playSound(id: String) {
        guard id != Sound.all.first?.id else {
            AudioServicesPlayAlertSound(SystemSoundID(1007))
            return
        }
        guard let path = Bundle.main.path(
            forResource: id,
            ofType: "mp3"
        ) else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player?.play()
        } catch {
            logger.critical("playSound(): \(error)")
        }
    }
}
