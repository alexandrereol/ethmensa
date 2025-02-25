//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
