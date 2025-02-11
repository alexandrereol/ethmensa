//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Network
import SwiftUI

/// Responsible for managing network-related operations within the application.
class NetworkManager: ObservableObject {
    /// A singleton instance of `NetworkManager` to manage mensa data.
    ///
    /// Use `NetworkManager.shared` to access the shared instance.
    static let shared = NetworkManager()

    /// The NWPathMonitor instance used for monitoring network status.
    ///
    /// This property holds the `NWPathMonitor` instance that is responsible for monitoring the network status.
    /// It is initialized when network monitoring starts and deinitialized when network monitoring stops.
    private var nwMonitor: NWPathMonitor?

    /// A flag indicating whether network monitoring is currently active.
    ///
    /// This property is `true` if network monitoring is currently active, and `false` otherwise.
    private var isNwMonitoring = false

    /// A published property that indicates whether the network is offline.
    /// When `true`, the network is offline; when `false`, the network is online.
    @Published var isOffline = false

    /// A computed property that returns whether the device has cellular capabilities.
    ///
    /// This property returns `true` if the device has cellular capabilities, and `false` otherwise.
    /// It checks the available interfaces of the `NWPathMonitor` instance to determine if cellular capabilities
    /// are present.
    var hasCellularCapabilities: Bool {
        if let monitor = nwMonitor {
            monitor.currentPath.availableInterfaces.map(\.type).contains { $0 == .cellular }
        } else {
            false
        }
    }

    /// Starts network monitoring.
    ///
    /// This method starts the network monitoring process. It initializes the `NWPathMonitor` instance and
    /// sets up a dispatch queue for monitoring. The `pathUpdateHandler` closure is set to handle network status
    /// changes.If network monitoring is already active, this method does nothing.
    func startNwMonitoring() {
        if isNwMonitoring { return }
        nwMonitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NWMonitor")
        nwMonitor?.start(queue: queue)
        nwMonitor?.pathUpdateHandler = { _ in
            Task { @MainActor in
                self.isOffline = self.nwMonitor?.currentPath.status != .satisfied
            }
        }
        isNwMonitoring = true
    }

    /// Stops network monitoring.
    ///
    /// This method stops the network monitoring process. It cancels the `NWPathMonitor` instance and
    /// deinitializes it. The `handleDidStoppedNetworkMonitoring` closure is called to handle any actions
    /// that need to be taken when network monitoring stops. If network monitoring is not active, this method does
    /// nothing.
    func stopMonitoring() {
        if isNwMonitoring, let monitor = nwMonitor {
            monitor.cancel()
            self.nwMonitor = nil
            isNwMonitoring = false
        }
    }
}
