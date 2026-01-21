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

struct CheckMarkView: View {

    var text: String
    var shown: Bool

    var body: some View {
        if shown {
            LabeledContent {
                Image(systemName: "checkmark")
                    .foregroundColor(.accent)
            } label: {
                Text(text)
            }
        } else {
            Text(text)
        }
    }
}

#Preview {
    List {
        CheckMarkView(text: "Hello World!", shown: true)
        CheckMarkView(text: "Hello World!", shown: false)
    }
}
