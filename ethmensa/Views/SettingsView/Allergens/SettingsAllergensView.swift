//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
            }
            Section("MY_ALLERGENS") {
                ForEach(Allergen.allCases) { allergen in
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
                            text: allergen.localizedString.capitalized,
                            shown: settingsManager.allergens.contains {
                                $0.id == allergen.id
                            }
                        )
                    }
                    .tint(.primary)
                }
            }
        }
        .navigationTitle("ALLERGENS")
        .navigationBarTitleDisplayMode(.inline)
    }

    private struct CheckMarkView: View {

        var text: String
        var shown: Bool

        var body: some View {
            if shown {
                Text(text)
                    .badge(
                        Text("\(Image(systemName: "checkmark"))")
                            .foregroundColor(.accent)
                    )
            } else {
                Text(text)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsAllergensView()
            .environmentObject(SettingsManager.shared)
    }
}
