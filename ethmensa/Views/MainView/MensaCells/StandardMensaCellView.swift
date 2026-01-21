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
                            Image(.appIconRoundedForUserVersion)
                                .resizable()
                        } content: { image in
                            image
                                .resizable()
                        }
                    } else {
                        Image(.appIconRoundedForUserVersion)
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
