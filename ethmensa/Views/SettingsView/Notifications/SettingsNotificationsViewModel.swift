//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI
import Combine

#if !os(visionOS)
import CoreLocation
#endif

@MainActor
class SettingsNotificationsViewModel: NSObject, ObservableObject {

    @Published var notifications = SettingsManager.shared.notifications
    @Published var notificationDeniedAlertShown = false
    @Published var notificationNotSupportedAlertShown = false

#if !os(visionOS)
    @Published var location = SettingsManager.shared.location
    @Published var locationDeniedAlertShown = false
    @Published var locationNotSupportedAlertShown = false

    @Published private var loadedLocationPermission = false

    private var coreLocationManager = CLLocationManager()
#endif

    private var subscribers: Set<AnyCancellable> = []

    override init() {
        super.init()
        $notifications.sink { receivedValue in
            if ProcessInfo.isXcodePreview {
                return
            }
            Task {
                try? await self.notificationChange(receivedValue)
            }
        }.store(in: &subscribers)
#if !os(visionOS)
        $location.sink { receivedValue in
            if ProcessInfo.isXcodePreview {
                return
            }
            Task {
                try? await self.locationChange(receivedValue)
            }
        }.store(in: &subscribers)
        coreLocationManager.delegate = self
#endif
    }

    private func notificationChange(_ newNotifications: Bool) async throws {
        if newNotifications {
            let unc = UNUserNotificationCenter.current()
            switch await unc.notificationSettings().authorizationStatus {
            case .authorized:
                await MainActor.run {
                    SettingsManager.shared.notifications = true
                }
            case .denied:
                setNotificationToggleBack()
                await MainActor.run {
                    notificationDeniedAlertShown = true
                }
            case .notDetermined:
                try await unc.requestAuthorization(options: [
                    .alert,
                    .badge,
                    .carPlay,
                    .providesAppNotificationSettings,
                    .sound
                ])
                try await notificationChange(true)
            case .provisional, .ephemeral:
                setNotificationToggleBack()
                await MainActor.run {
                    notificationNotSupportedAlertShown = true
                }
            @unknown default:
                setNotificationToggleBack()
                await MainActor.run {
                    notificationNotSupportedAlertShown = true
                }
            }
        } else {
            SettingsManager.shared.notifications = false
        }
    }

    private func setNotificationToggleBack() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.notifications = false
        }
    }

    func deniedAction() {
        guard let openSettingsURL = UIApplication.openSettingsURLString.toURL() else {
            return
        }
        UIApplication.shared.open(openSettingsURL)
    }

#if !os(visionOS)

    private func locationChange(_ newLocation: Bool) async throws {
        if newLocation {
            switch coreLocationManager.authorizationStatus {
            case .authorized, .authorizedAlways:
                SettingsManager.shared.location = true
            case .authorizedWhenInUse:
                coreLocationManager.requestAlwaysAuthorization()
            case .denied, .restricted:
                setLocationToggleBack()
                await MainActor.run {
                    locationDeniedAlertShown = true
                }
            case .notDetermined:
                coreLocationManager.requestAlwaysAuthorization()
            @unknown default:
                setLocationToggleBack()
                await MainActor.run {
                    locationDeniedAlertShown = true
                }
            }
        } else {
            SettingsManager.shared.location = false
        }
    }

    private func setLocationToggleBack() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.location = false
        }
    }
#endif
}

#if !os(visionOS)
extension SettingsNotificationsViewModel: @preconcurrency CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if loadedLocationPermission {
            Task {
                try? await locationChange(true)
            }
        } else {
            loadedLocationPermission = true
        }
    }
}
#endif
