//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI
import URLImage

struct StandardMensaCellView: View {

    var mensa: Mensa
    var isLoading: Bool

    var body: some View {
        NavigationLink(value: mensa) {
            HStack {
                Group {
                    if let url = mensa.imageURL {
                        URLImage(url: url) {
                            Color.gray
                        } inProgress: { _ in
                            Color.gray
                        } failure: { _, _ in
                            Image(.appIconRounded)
                                .resizable()
                        } content: { image in
                            image
                                .resizable()
                        }
                    } else {
                        Image(.appIconRounded)
                            .resizable()
                    }
                }
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(10)
                .padding(.trailing, 10)
                VStack(alignment: .leading) {
                    Text(mensa.name)
                    SharedWithYouView(
                        swhighlight: mensa.swHighlight
                    )
                }
                Spacer()
                OpeningTimesCircle(
                    mensa: mensa,
                    isLoading: isLoading
                )
            }
        }
#if targetEnvironment(macCatalyst)
        .padding(.vertical, 5)
#endif
    }
}

#Preview("Sample Data") {
    NavigationSplitView {
        List {
            ForEach(0...10, id: \.self) { _ in
                StandardMensaCellView(
                    mensa: .example,
                    isLoading: false
                )
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
                StandardMensaCellView(
                    mensa: .example,
                    isLoading: true
                )
                .redacted(reason: .placeholder)
            }
        }
    } detail: {
        EmptyView()
    }
}
