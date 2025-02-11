//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct SettingsCellView<Content: View>: View {

    var label: String
    var systemImageName: String?

    @ViewBuilder let content: Content

    var body: some View {
        NavigationLink {
            content
        } label: {
            if let systemImageName {
                Label(label, systemImage: systemImageName)
            } else {
                Text(label)
            }
        }
    }
}

#Preview {
    NavigationStack {
        List {
            SettingsCellView(
                label: String("Hello World!"),
                systemImageName: "swift"
            ) {
                Text(String("Hello World!"))
            }
        }
    }
}
