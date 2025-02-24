//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
