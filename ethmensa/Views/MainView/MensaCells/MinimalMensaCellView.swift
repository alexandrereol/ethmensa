//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct MinimalMensaCellView: View {

    var mensa: Mensa
    var isLoading: Bool

    private var idiomIsPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }

    var body: some View {
        NavigationLink(value: mensa) {
            HStack {
                VStack(alignment: .leading) {
                    Text(mensa.name)
                    if !idiomIsPhone {
                        SharedWithYouView(
                            swhighlight: mensa.swHighlight
                        )
                    }
                }
                .padding(.vertical, 5)
                Spacer()
                if idiomIsPhone {
                    SharedWithYouView(
                        swhighlight: mensa.swHighlight
                    )
                    .padding(.trailing, 10)
                }
                OpeningTimesCircle(
                    mensa: mensa,
                    isLoading: isLoading
                )
                .padding(.trailing, 5)
            }
        }
        .disabled(isLoading)
    }
}

#Preview("Sample Data") {
    NavigationSplitView {
        List {
            ForEach(0...10, id: \.self) { _ in
                MinimalMensaCellView(
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
                MinimalMensaCellView(
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
