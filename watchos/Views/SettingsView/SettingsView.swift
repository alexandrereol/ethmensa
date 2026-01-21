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

struct SettingsView: View {

    @EnvironmentObject var settingsManager: SettingsManager

    @State private var debugSheetShown = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        SettingsAppearanceView()
                            .environmentObject(settingsManager)
                    } label: {
                        SettingsElementLabel(text: "PRICE_TO_SHOW")
                    }
                } footer: {
                    Text("PRICE_TO_SHOW_FOOTER")
                }
                Section {
                    NavigationLink {
                        AdvancedSettingsView()
                    } label: {
                        SettingsElementLabel(text: "ADVANCED_SETTINGS")
                    }
                }
                Section {
                    NavigationLink {
                        ModalViewUI(viewModel: .about)
                            .sheet(isPresented: $debugSheetShown) {
                                DebugView()
                            }
                    } label: {
                        SettingsElementLabel(text: "ABOUT_\(Bundle.main.displayName)")
                    }
                }
            }
            .navigationTitle("SETTINGS")
        }
    }

    private struct SettingsElementLabel: View {

        var text: String.LocalizationValue

        var body: some View {
            HStack {
                Text(String(localized: text))
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
    }
}

#Preview {
    NavigationStack {
        Text(String("Hello World!"))
            .sheet(isPresented: .constant(true)) {
                SettingsView()
            }
    }
}
