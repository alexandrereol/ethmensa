//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct MainViewToolbar: ToolbarContent {

    @Binding var mensaShowType: MensaShowType
    @Binding var mensaLocationType: Campus.CampusType
    @Binding var sortBy: SortType
    @Binding var mensaCellType: MensaCellType

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

    private var nonstandardSortOptions: Bool {
        mensaShowType != .all &&
        mensaLocationType != .all &&
        sortBy != .def
    }
    
    var filterMenu: some View {
        Menu {
            let selectedOpenOnly = Binding<Bool>(
                get: { mensaShowType == .open },
                set: { mensaShowType = $0 ? .open : .all }
            )
            Toggle("\(String(localized: "OPEN_ONLY"))", isOn: selectedOpenOnly)
            let alphabeticSorting = Binding<Bool>(
                get: { sortBy == .name },
                set: { sortBy = $0 ? .name : .def }
            )
            Toggle("\(String(localized: "ALPHABETIC_SORTING"))", isOn: alphabeticSorting)
            Divider()
            let selectedCampus = Binding<Optional<Campus.CampusType>>(
                get: { mensaLocationType == .all ? nil : mensaLocationType },
                set: {
                    if let newValue = $0 {
                        mensaLocationType = newValue
                    } else {
                        mensaLocationType = .all
                    }
                }
            )
            Picker(String(""),selection: selectedCampus) {
                ForEach(Campus.CampusType.allCases.filter{$0 != .all}, id: \.rawValue) { showType in
                    Text(showType.localizedString).tag(Optional(showType))
                }
            }
            Divider()
            Picker("MENSA_CELL_SIZE", selection: $mensaCellType) {
                ForEach(cellTypes, id: \.type) { viewType in
                    Text(viewType.name)
                        .tag(viewType.type)
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
        }
    }
    
    var filterMenuVerbose: some View {
        Menu {
            Picker(String(""),selection: $mensaShowType) {
                ForEach(MensaShowType.allCases, id: \.rawValue) { showType in
                    Text(showType.localizedString).tag(showType)
                }
            }
            Divider()
            Picker(String(""),selection: $mensaLocationType) {
                ForEach(Campus.CampusType.allCases, id: \.rawValue) { showType in
                    Text(showType.localizedString).tag(showType)
                }
            }
            Divider()
            Picker(String(""),selection: $sortBy) {
                ForEach(SortType.allCases, id: \.rawValue) { showType in
                    Text(showType.localizedString).tag(showType)
                }
            }
            Divider()
            Picker("MENSA_CELL_SIZE", selection: $mensaCellType) {
                ForEach(cellTypes, id: \.type) { viewType in
                    Text(viewType.name)
                        .tag(viewType.type)
                }
            }
        } label: {
            Image(systemName: "square.text.square")
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
