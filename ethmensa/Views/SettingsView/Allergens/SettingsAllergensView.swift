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

struct SettingsAllergensView: View {

    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        List {
            Section {
                Toggle(
                    "SHOW_IN_MENUS",
                    isOn: $settingsManager.showAllergens
                )
                .tint(.accentColor)
            } header: {
                Spacer(minLength: 0).frame(height: 10).listRowInsets(EdgeInsets())
            }
            Section("MY_ALLERGENS") {
                ForEach(Allergen.allCases) { allergen in
                    // Sentence case, not .capitalized: "Sulphur dioxide", not "Sulphur Dioxide"
                    let name = allergen.localizedString
                    Button {
                        if let index = settingsManager.allergens.firstIndex(where: { currentAllergen in
                            currentAllergen.id == allergen.id
                        }) {
                            settingsManager.allergens.remove(at: index)
                        } else {
                            settingsManager.allergens.append(allergen)
                        }
                    } label: {
                        CheckMarkView(
                            text: name.prefix(1).localizedUppercase + name.dropFirst(),
                            shown: settingsManager.allergens.contains {
                                $0.id == allergen.id
                            }
                        )
                    }
                    .tint(.primary)
                }
            }
        }
        .environment(\.defaultMinListHeaderHeight, 0)
        .navigationTitle("ALLERGENS")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsAllergensView()
            .environmentObject(SettingsManager.shared)
    }
}
