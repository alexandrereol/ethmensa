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

struct AllMensasClosedTodayView: View {

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "frying.pan")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            Text("THERE_ARE_NO_MENUS_AVAILABLE_TODAY.")
                .fontWeight(.medium)
        }
        .padding(.top, 20)
        .multilineTextAlignment(.center)
        .containerBackground(.blue.gradient, for: .navigation)
        .navigationTitle {
            Text(Bundle.main.displayName)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    NavigationStack {
        AllMensasClosedTodayView()
            .environmentObject(NavigationManager.example)
    }
}
