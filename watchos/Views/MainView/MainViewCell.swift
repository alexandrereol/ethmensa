//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
