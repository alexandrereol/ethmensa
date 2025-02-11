//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI
import URLImage

struct LargeMensaCellView: View {

    @Environment(\.colorScheme) var colorScheme

    var mensa: Mensa
    var isLoading: Bool

    var body: some View {
        if let url = mensa.imageURL {
            ZStack {
                NavigationLink(value: mensa) {
                    EmptyView()
                }
                .disabled(isLoading)
                .opacity(0)
                URLImage(url: url) {
                    Color.gray
                } inProgress: { _ in
                    Color.gray
                } failure: { _, _ in
                    Color.gray
                } content: { image in
                    image
                        .resizable()
                }
                .scaledToFill()
                .ignoresSafeArea()
                .frame(maxHeight: 140)
                .padding(-45)
                VStack(alignment: .leading) {
                    SharedWithYouView(
                        swhighlight: mensa.swHighlight
                    )
                    .padding(.top, 15)
                    Spacer()
                    bottomBarView
                }
                .frame(height: 140)
            }
        } else {
            MinimalMensaCellView(mensa: mensa, isLoading: isLoading)
        }
    }

    private var bottomBarView: some View {
        Rectangle()
            .foregroundStyle(
                Color(
                    uiColor: .secondarySystemGroupedBackground
                )
            )
            .ignoresSafeArea()
            .frame(height: 50)
            .padding(.bottom, -11)
            .padding(.leading, -20)
            .padding(.trailing, -40)
            .overlay {
                HStack {
                    Text(mensa.name)
                    Spacer()
                    OpeningTimesCircle(
                        mensa: mensa,
                        isLoading: isLoading
                    )
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12.5, height: 12.5)
                        .foregroundStyle(.tertiary)
                }
                .padding(.top, 11)
            }
    }
}

#Preview("Sample Data") {
    NavigationSplitView {
        List {
            ForEach(0...10, id: \.self) { _ in
                Section {
                    LargeMensaCellView(
                        mensa: .example,
                        isLoading: false
                    )
                }
            }
        }
    } detail: {
        EmptyView()
    }
}

#Preview("Loading") {
    NavigationSplitView {
        List {
            ForEach(0...10, id: \.self) { _ in
                Section {
                    LargeMensaCellView(
                        mensa: .example,
                        isLoading: true
                    )
                    .redacted(reason: .placeholder)
                }
            }
        }
    } detail: {
        EmptyView()
    }
}
