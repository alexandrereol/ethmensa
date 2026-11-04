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

/// The value of a window that shows a single Mensa, see `MensaWindowView`.
///
/// Windows are told apart by their Mensa only, so opening a Mensa that is already open brings its window to the front.
struct MensaWindow: Codable, Hashable {
    /// The identifier of the Mensa shown in the window.
    let mensaId: String

    /// The weekday the window was opened for, or `nil` for today.
    var weekdayCode: Int?

    /// The `targetContentIdentifier` of user activities that open a Mensa in a new window,
    /// see `Scene.handlesExternalEvents(matching:)`.
    static let externalEventIdentifier = "ch.alexandrereol.ethmensa.mensaWindow"

    /// The `userInfo` key of the weekday in a user activity that opens a Mensa in a new window.
    static let weekdayCodeKey = "weekdayCode"

    init(mensaId: String, weekdayCode: Int? = nil) {
        self.mensaId = mensaId
        self.weekdayCode = weekdayCode
    }

    /// Creates the value of a window from a user activity, e.g. of a Mensa dragged to the edge of the screen.
    init?(activity: NSUserActivity) {
        guard let mensaId = activity.userInfo?[Mensa.handoffMensaIdKey] as? String else {
            return nil
        }
        self.init(mensaId: mensaId, weekdayCode: activity.userInfo?[Self.weekdayCodeKey] as? Int)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.mensaId == rhs.mensaId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(mensaId)
    }
}

extension Mensa {
    /// An item provider for dragging this Mensa: its share URL, and a user activity
    /// that opens it in a new window when it is dropped at the edge of the screen.
    /// - Parameter weekdayCode: The weekday to show in the new window, or `nil` for today.
    func dragItemProvider(weekdayCode: Int?) -> NSItemProvider {
        let itemProvider = NSItemProvider(object: shareURL as NSURL)
        let activity = NSUserActivity(activityType: Self.handoffActivityType)
        configure(activity)
        if let weekdayCode {
            activity.addUserInfoEntries(from: [MensaWindow.weekdayCodeKey: weekdayCode])
        }
        activity.targetContentIdentifier = MensaWindow.externalEventIdentifier
        itemProvider.registerObject(activity, visibility: .all)
        return itemProvider
    }
}

/// Restores the selected Mensa and weekday of a window after relaunch, and saves them while they change.
private struct WindowStateRestorationModifier: ViewModifier {

    @ObservedObject var navigationManager: NavigationManager

    @Binding var selectedMensaId: String?
    @Binding var selectedWeekdayCode: Int?

    func body(content: Content) -> some View {
        content
            .onAppear {
                guard navigationManager.selectedMensa == nil,
                      let selectedMensaId else {
                    return
                }
                navigationManager.restoredWeekdayCode = selectedWeekdayCode
                navigationManager.restoredMensaId = selectedMensaId
            }
            .onChange(of: navigationManager.selectedMensa?.id) { mensaId in
                selectedMensaId = mensaId
            }
            .onChange(of: navigationManager.selectedWeekdayCode) { weekdayCode in
                selectedWeekdayCode = weekdayCode
            }
    }
}

/// The content of a main window: the mensa list and the selected Mensa.
///
/// Every window has its own `NavigationManager`, so windows navigate, filter and search independently.
struct MainWindowView: View {

    @Environment(\.scenePhase) private var scenePhase

    @StateObject private var navigationManager = NavigationManager()

    @SceneStorage("MainWindowView.selectedMensaId") private var selectedMensaId: String?
    @SceneStorage("MainWindowView.selectedWeekdayCode") private var selectedWeekdayCode: Int?

    var body: some View {
        AppView()
            .environmentObject(navigationManager)
            // Links and Handoff open in a main window that is already open, instead of a new one.
            .handlesExternalEvents(preferring: ["*"], allowing: ["*"])
            .modifier(
                WindowStateRestorationModifier(
                    navigationManager: navigationManager,
                    selectedMensaId: $selectedMensaId,
                    selectedWeekdayCode: $selectedWeekdayCode
                )
            )
            .background {
                WindowSceneReader { windowScene in
                    navigationManager.windowScene = windowScene
                }
            }
            .onAppear {
                navigationManager.becomePrimaryWindow()
            }
            .onChange(of: scenePhase) { scenePhase in
                if scenePhase == .active {
                    navigationManager.becomePrimaryWindow()
                }
            }
    }
}

/// The content of a window that shows a single Mensa, opened from the context menu of a Mensa
/// or by dragging a Mensa to the edge of the screen.
struct MensaWindowView: View {

    @Binding var window: MensaWindow?

    @StateObject private var navigationManager = NavigationManager()

    // The Mensa is also saved here, as a window opened by dropping a Mensa sets its value only after it is created.
    @SceneStorage("MensaWindowView.mensaId") private var mensaId: String?
    @SceneStorage("MensaWindowView.selectedWeekdayCode") private var selectedWeekdayCode: Int?

    var body: some View {
        NavigationStack {
            DetailView()
        }
        .environmentObject(navigationManager)
        .fullScreenCover(isPresented: $navigationManager.imagePopoverShown) {
            if let url = navigationManager.imagePopoverURL {
                FullscreenImageView(url: url)
            }
        }
        // Links and Handoff open in a main window, never in a Mensa window.
        .handlesExternalEvents(preferring: [], allowing: [MensaWindow.externalEventIdentifier])
        // A Mensa dropped at the edge of the screen opens a new window, with the Mensa in a user activity.
        .onContinueUserActivity(Mensa.handoffActivityType) { activity in
            guard window == nil else {
                return
            }
            window = MensaWindow(activity: activity)
        }
        .onAppear {
            if window == nil, let mensaId {
                window = MensaWindow(mensaId: mensaId)
            }
            show(window)
        }
        .onChange(of: window) { window in
            show(window)
        }
        .onChange(of: navigationManager.selectedWeekdayCode) { weekdayCode in
            selectedWeekdayCode = weekdayCode
        }
    }

    /// Shows the Mensa of the window, on the weekday it last showed or was opened for.
    private func show(_ window: MensaWindow?) {
        guard let window,
              navigationManager.selectedMensa?.id != window.mensaId else {
            return
        }
        mensaId = window.mensaId
        navigationManager.restoredWeekdayCode = selectedWeekdayCode ?? window.weekdayCode
        navigationManager.restoredMensaId = window.mensaId
    }
}

/// Reads the scene of the window the view is shown in.
private struct WindowSceneReader: UIViewRepresentable {

    let onChange: (UIWindowScene?) -> Void

    func makeUIView(context: Context) -> ReaderView {
        ReaderView(onChange: onChange)
    }

    func updateUIView(_ uiView: ReaderView, context: Context) {}

    final class ReaderView: UIView {
        let onChange: (UIWindowScene?) -> Void

        init(onChange: @escaping (UIWindowScene?) -> Void) {
            self.onChange = onChange
            super.init(frame: .zero)
            isUserInteractionEnabled = false
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func didMoveToWindow() {
            super.didMoveToWindow()
            onChange(window?.windowScene)
        }
    }
}
