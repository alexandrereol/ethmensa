//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct CheckMarkView: View {

    var text: String
    var shown: Bool

    var body: some View {
        if shown {
            LabeledContent {
                Image(systemName: "checkmark")
                    .foregroundColor(.accent)
            } label: {
                Text(text)
            }
        } else {
            Text(text)
        }
    }
}

#Preview {
    List {
        CheckMarkView(text: "Hello World!", shown: true)
        CheckMarkView(text: "Hello World!", shown: false)
    }
}
