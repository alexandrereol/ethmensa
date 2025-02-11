//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
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
