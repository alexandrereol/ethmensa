//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct DetailViewToolbar: ToolbarContent {

    var selectedMensa: Mensa?

    @State var shareSheetShown = false

    var body: some ToolbarContent {
        if let selectedMensa {
            ToolbarItem(placement: .topBarTrailing) {
                Button("SHARE", systemImage: "square.and.arrow.up") {
                    shareSheetShown = true
                }
                .popover(isPresented: $shareSheetShown) {
                    UIActivityView(
                        name: selectedMensa.name,
                        url: selectedMensa.shareURL,
                        image: .appIconRounded,
                        excludedActivityTypes: []
                    )
                    .presentationDetents([.medium])
                }
            }
        }
    }
}
