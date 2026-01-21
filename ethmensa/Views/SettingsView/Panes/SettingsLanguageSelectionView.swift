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
