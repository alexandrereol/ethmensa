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
