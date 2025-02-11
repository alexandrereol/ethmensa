//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct FilterView: View {

    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        List {
            Picker("CURRENT_STATUS", selection: $settingsManager.mensaShowType) {
                ForEach(MensaShowType.allCases, id: \.rawValue) { showType in
                    Text(showType.localizedString)
                        .tag(showType)
                }
            }
            Picker("LOCATION", selection: $settingsManager.mensaLocationType) {
                ForEach(Campus.CampusType.allCases, id: \.rawValue) { showType in
                    Text(showType.localizedString)
                        .tag(showType)
                }
            }
            Picker("SORT_BY", selection: $settingsManager.sortBy) {
                ForEach(SortType.allCases, id: \.rawValue) { showType in
                    Text(showType.localizedString)
                        .tag(showType)
                }
            }
        }
        .pickerStyle(.inline)
        .navigationTitle("FILTER_OPTIONS")
    }
}

#Preview {
    Text(String("Hello World!"))
        .sheet(isPresented: .constant(true)) {
            FilterView()
                .environmentObject(SettingsManager.shared)
        }
}
