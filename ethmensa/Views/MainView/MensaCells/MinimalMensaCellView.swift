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
