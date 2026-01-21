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
import SwiftUI

struct SoundSelectionView: View {

    @EnvironmentObject var settingsManager: SettingsManager

    @StateObject private var viewModel = SoundSelectionViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    if let defaultSound = Sound.all.first {
                        Button {
                            settingsManager.notificationsSound = defaultSound.id
                            viewModel.playSound(id: defaultSound.id)
                        } label: {
                            CheckMarkView(
                                text: defaultSound.localizedName,
                                shown: defaultSound.id == settingsManager.notificationsSound
                            )
                        }
                    }
                }
                Section {
                    ForEach(Sound.all.dropFirst()) { sound in
                        Button {
                            settingsManager.notificationsSound = sound.id
                            viewModel.playSound(id: sound.id)
                        } label: {
                            CheckMarkView(
                                text: sound.localizedName,
                                shown: sound.id == settingsManager.notificationsSound
                            )
                        }
                    }
                }
            }
            .navigationTitle("NOTIFICATION_SOUND")
            .navigationBarTitleDisplayMode(.inline)
            .tint(.primary)
        }
    }

    private struct CheckMarkView: View {

        var text: String
        var shown: Bool

        var body: some View {
            LabeledContent(text) {
                if shown {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.accent)
                }
            }
        }
    }
}

#Preview {
    SoundSelectionView()
        .environmentObject(SettingsManager.shared)
}
