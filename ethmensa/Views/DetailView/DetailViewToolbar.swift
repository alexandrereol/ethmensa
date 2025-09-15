//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct DetailViewToolbar: ToolbarContent {

    var selectedMensa: Mensa?

    var body: some ToolbarContent {
        if let selectedMensa {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(
                    item: selectedMensa.shareURL,
                    preview: .init(
                        selectedMensa.name,
                        image: Image(uiImage: .appIconRoundedForUserVersion)
                    )
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        Text(String("Hello World!"))
            .toolbar {
                DetailViewToolbar(selectedMensa: .example)
            }
    }
}
