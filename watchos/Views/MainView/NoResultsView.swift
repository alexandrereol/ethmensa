//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct NoResultsView: View {

    @EnvironmentObject var mensaDataManager: MensaDataManager

    var body: some View {
        VStack(spacing: 20) {
            Text("NO_RESULTS_FOR_SELECTED_FILTERS.")
                .fontWeight(.medium)
            Button("RESET_FILTERS") {
                Task {
                    await mensaDataManager.resetFiltersAndSearch()
                }
            }
            .padding(.horizontal, 10)
        }
        .padding(.top, 20)
        .multilineTextAlignment(.center)
        .containerBackground(.blue.gradient, for: .navigation)
    }
}

#Preview {
    NavigationStack {
        NoResultsView()
            .environmentObject(MensaDataManager.shared)
    }
}
