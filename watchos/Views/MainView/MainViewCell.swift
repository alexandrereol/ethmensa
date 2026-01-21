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

struct MainViewCell: View {

    var mensa: Mensa

    var body: some View {
        NavigationLink(value: mensa) {
            HStack {
                Text(mensa.name)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                    .padding(.trailing, 5)
                    .padding(.vertical, 15)
                Spacer()
                OpeningTimesCircle(
                    mensa: mensa,
                    isLoading: false
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        List {
            MainViewCell(mensa: .example)
            MainViewCell(mensa: .example)
            MainViewCell(mensa: .example)
        }
    }
}
