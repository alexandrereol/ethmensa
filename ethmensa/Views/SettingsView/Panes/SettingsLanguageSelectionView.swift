//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct SettingsLanguageSelectionView: View {
    let languages = [
        (code: "en-US", name: "English"),
        (code: "de-CH", name: "Deutsch"),
        (code: "fr-CH", name: "Français"),
        (code: "it-CH", name: "Italiano")
    ]

    @State private var appleLanguages: [String] = UserDefaults.standard.array(
        forKey: "AppleLanguages"
    ) as? [String] ?? Locale.preferredLanguages

    var body: some View {
        List {
            Section {
                ForEach(languages, id: \.code) { language in
                    Button {
                        setLanguage(language.code)
                    } label: {
                        CheckMarkView(
                            text: language.name,
                            shown: appleLanguages.first == language.code
                        )
                    }
                    .tint(.primary)
                }
            } footer: {
                Text("LANGUAGE_CHANGE_ON_APP_RESTART")
            }
        }
        .navigationTitle("LANGUAGE")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func setLanguage(_ code: String) {
        var newOrder = [code]
        for lang in appleLanguages where lang != code {
            newOrder.append(lang)
        }
        appleLanguages = newOrder
        UserDefaults.standard.set(newOrder, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}

#Preview {
    NavigationStack {
        SettingsLanguageSelectionView()
    }
}
