//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct MainViewToolbar: ToolbarContent {

    var showFilterButton = true
    var isFiltered: Bool

    private var filterImageName: String {
        "line.3.horizontal.decrease.circle\(isFiltered ? ".fill" : "")"
    }

    var body: some ToolbarContent {
        if showFilterButton {
            ToolbarItem(placement: .topBarLeading) {
                Button("FILTER", systemImage: filterImageName) {
                    NavigationManager.shared.sheet = .filter
                }
                .labelStyle(.iconOnly)
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button("SETTINGS", systemImage: "gear") {
                NavigationManager.shared.sheet = .settings
            }
            .labelStyle(.iconOnly)
        }
    }
}
