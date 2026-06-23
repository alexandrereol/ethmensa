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

struct LargeMensaCellView: View {

    @Environment(\.colorScheme) private var colorScheme

    var mensa: Mensa
    var isLoading: Bool

    var body: some View {
        if let url = mensa.imageURL {
            ZStack {
                NavigationLink(value: mensa) {
                    EmptyView()
                }
                .opacity(0)
                .accessibilityHidden(true)
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
                .accessibilityHidden(true)
                VStack(alignment: .leading) {
                    SharedWithYouView(
                        swhighlight: mensa.swHighlight
                    )
                    .padding(.top, 15)
                    .accessibilityLabel(String(localized: "SHARED_WITH_YOU"))
                    Spacer()
                    bottomBarView
                }
                .frame(height: 140)
            }
            .accessibilityElement(children: .combine)
            .accessibilityHint(String(localized: "DOUBLE_TAP_TO_VIEW_MENU"))
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
            .padding(.bottom, -15)
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
                        .accessibilityHidden(true)
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
