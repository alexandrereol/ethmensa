//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct CheckMarkView: View {

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
