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

import AVFoundation
import os.log
import SwiftUI

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
            logger.critical("\(#function): \(error)")
        }
    }
}
