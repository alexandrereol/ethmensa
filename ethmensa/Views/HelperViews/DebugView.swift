//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Combine
import SwiftUI

#if !os(watchOS)
import SharedWithYou
#endif

// MARK: Open the debug menu by going to Settings → About → tap 10x on the app icon

struct DebugView: View {

    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        NavigationStack {
            List {
                Section(String("URLCache.shared")) {
                    Button(String("removeAllCachedResponses()")) {
                        URLCache.shared.removeAllCachedResponses()
                    }
                }
                Section {
                    Toggle("DEBUG", isOn: $settingsManager.debugMode)
                    Toggle(String("Screenshot mode"), isOn: $settingsManager.screenshotMode)
                }
                Section(String("KVS")) {
                    NavigationLink(String("KVS")) {
                        List {
                            ForEach(settingsManager.kvs.dictionaryRepresentation.map { (key, value) in
                                "\(key)\n\n\(value)"
                            }, id: \.self) { entry in
                                Text(entry)
                            }
                        }
                    }
                    NavigationLink(String("KVS (filtered)")) {
                        List {
                            ForEach(settingsManager.kvs.dictionaryRepresentation.filter { (key, _) in
                                SettingsManager.Prefix.isPrefixMatching(key: key)
                            }.map { (key, value) in
                                "\(key)\n\n\(value)"
                            }, id: \.self) { entry in
                                Text(entry)
                            }
                        }
                    }
                }
                Section(String("UserDefaults")) {
                    NavigationLink(String("UserDefaults")) {
                        List {
                            ForEach(settingsManager.udf.dictionaryRepresentation().map { (key, value) in
                                "\(key)\n\n\(value)"
                            }, id: \.self) { entry in
                                Text(entry)
                            }
                        }
                    }
                    NavigationLink(String("UserDefaults (filtered)")) {
                        List {
                            ForEach(settingsManager.udf.dictionaryRepresentation().filter { (key, _) in
                                SettingsManager.Prefix.isPrefixMatching(key: key)
                            }.map { (key, value) in
                                "\(key)\n\n\(value)"
                            }, id: \.self) { entry in
                                Text(String(entry))
                            }
                        }
                    }
                }
                Section(String("CoreData")) {
                    NavigationLink(String("CoreData: ClickCount")) {
                        List {
                            ForEach(ClickCountDBManager.shared.read()) { clickCount in
                                Section {
                                    Text(clickCount.id)
                                    Text(String(clickCount.count))
                                }
                            }
                        }
                    }
                    NavigationLink(String("CoreData: GeoCache")) {
                        List {
                            ForEach(GeoCacheDBManager.shared.read()) { geoCache in
                                Section {
                                    Text(geoCache.address)
                                    Text(String("Longitude: \(geoCache.long) | Latitude: \(geoCache.lat)"))
                                }
                            }
                        }
                    }
                }
#if !os(watchOS)
                if let swHighlights = SharedWithYouManager.shared.swHighlights,
                   !swHighlights.isEmpty {
                    Section(String("Received SWHighlights")) {
                        ForEach(swHighlights, id: \.url) { highlight in
                            Text(highlight.url.absoluteString)
                        }
                    }
                }
#endif
            }
            .navigationTitle("DEBUG")
            .navigationBarTitleDisplayMode(.inline)
#if !os(watchOS)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("CLOSE") {
                        dismiss()
                    }
                }
            }
#endif
        }
        .tint(.red)
    }
}
