//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct CustomContentUnavailableView<Content>: View where Content: View {

    private var label: String
    private var systemImageName: String
    private var description: String
    private var actions: (() -> Content)?

    init(
        label: String,
        systemImageName: String,
        description: String,
        actions: (() -> Content)?
    ) {
        self.label = label
        self.systemImageName = systemImageName
        self.description = description
        self.actions = actions
    }

    var body: some View {
        if #available(iOS 17.0, *) {
            ContentUnavailableView {
                Label(label, systemImage: systemImageName)
            } description: {
                Text(description)
            } actions: {
                actions?()
            }
        } else {
            VStack(spacing: 10) {
                Image(systemName: systemImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
                Text(label)
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                Text(description)
                    .font(.system(size: 16))
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
                actions?()
            }
            .multilineTextAlignment(.center)
        }
    }
}

#Preview("Normal") {
    CustomContentUnavailableView(
        label: "Title",
        systemImageName: "app.dashed",
        description: "Description"
    ) {
        Button("Action") { }
    }
}
