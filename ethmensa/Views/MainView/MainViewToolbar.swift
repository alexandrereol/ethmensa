//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct MainViewToolbar: ToolbarContent {

    @Binding var mensaCellType: MensaCellType

    private var cellTypes: [(name: String, type: MensaCellType)] {
        var result: [(String, MensaCellType)] = [
            (.init(localized: "MINIMAL_VIEW"), .minimal),
            (.init(localized: "STANDARD_VIEW"), .standard)
        ]
        if UIDevice.current.userInterfaceIdiom == .phone {
            result.append(
                (String(localized: "LARGE_VIEW"), .large)
            )
        }
        return result
    }

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                Picker("MENSA_CELL_SIZE", selection: $mensaCellType) {
                    ForEach(cellTypes, id: \.type) { viewType in
                        Text(viewType.name)
                            .tag(viewType.type)
                    }
                }
            } label: {
                Image(systemName: "square.text.square")
            }
        }
#if !os(watchOS) && !os(visionOS) && !APPCLIP && !targetEnvironment(macCatalyst)
        ToolbarItem(placement: .topBarTrailing) {
            Button("LEGI_CARD", systemImage: "person.text.rectangle") {
                NavigationManager.shared.sheet = .legiCard
            }
        }
#endif
#if !APPCLIP
        ToolbarItem(placement: .topBarTrailing) {
            Button("SETTINGS", systemImage: "gear") {
                NavigationManager.shared.sheet = .settings
            }
        }
#endif
    }
}

#Preview {
    AppView()
        .environmentObject(NavigationManager.shared)
        .environmentObject(MensaDataManager.shared)
        .environmentObject(NetworkManager.shared)
        .environmentObject(SettingsManager.shared)
}
