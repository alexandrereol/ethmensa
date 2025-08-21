//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct MainViewToolbar: ToolbarContent {

    @Binding var filterOpenOnly: Bool
    @Binding var sortAlphabetically: Bool
    @Binding var filterCampus: Campus.CampusType?
    @Binding var mensaCellType: MensaCellType
    let isFiltered: Bool

    private var cellTypes: [(name: String, type: MensaCellType)] {
        var result: [(String, MensaCellType)] = [
            (.init(localized: "MINIMAL_VIEW"), .minimal),
            (.init(localized: "STANDARD_VIEW"), .standard)
        ]
        if UIDevice.current.userInterfaceIdiom == .phone {
            result.append(
                (String(localized: "LARGE_VIEW"), .large)
            )
        }
        return result
    }
    
    var filterMenu: some View {
        Menu {
            Section{
                Toggle("\(String(localized: "OPEN_ONLY"))", isOn: $filterOpenOnly.animation())
                Toggle("\(String(localized: "ALPHABETIC_SORTING"))", isOn: $sortAlphabetically.animation())
            }
            Section {
                let deselectableCampus = Binding {
                    filterCampus
                } set: { newValue in
                    withAnimation {
                        filterCampus = (newValue == filterCampus) ? nil : newValue
                    }
                }

                Picker(String(""),selection: deselectableCampus) {
                    ForEach(Campus.CampusType.allCases.filter{$0 != .all}, id: \.rawValue) { showType in
                        Text(showType.localizedString).tag(showType)
                    }
                }
            }
            Section {
                Picker("MENSA_CELL_SIZE", selection: $mensaCellType.animation()) {
                    ForEach(cellTypes, id: \.type) { viewType in
                        Text(viewType.name)
                            .tag(viewType.type)
                    }
                }
            }
        } label: {
            if (isFiltered){
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
            } else {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
        }
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            filterMenu
        }


    
        
    
#if !os(watchOS) && !os(visionOS) && !APPCLIP && !targetEnvironment(macCatalyst)
        ToolbarItem(placement: .topBarTrailing) {
            Button("LEGI_CARD", systemImage: "person.text.rectangle") {
                NavigationManager.shared.sheet = .legiCard
            }
        }
#endif
#if !APPCLIP
        ToolbarItem(placement: .topBarTrailing) {
            Button("SETTINGS", systemImage: "gear") {
                NavigationManager.shared.sheet = .settings
            }
        }
#endif
    }
}

#Preview {
    AppView()
        .environmentObject(NavigationManager.shared)
        .environmentObject(MensaDataManager.shared)
        .environmentObject(NetworkManager.shared)
        .environmentObject(SettingsManager.shared)
}
