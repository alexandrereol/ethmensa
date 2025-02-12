//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SwiftUI

struct ModalViewModel {
    init(
        type: Types,
        title: String,
        label1: String? = nil,
        label2: String? = nil,
        mainButtonLabel: String? = nil,
        detailButtonLabel: String? = nil,
        mainAction: (() -> Void)? = nil,
        detailAction: (() -> Void)? = nil,
        appIconPressAction: (() -> Void)? = nil,
        tintColor: Color = .accentColor
    ) {
        self.type = type
        self.title = title
        self.label1 = label1
        self.label2 = label2
        self.mainButtonLabel = mainButtonLabel
        self.detailButtonLabel = detailButtonLabel
        self.mainAction = mainAction
        self.detailAction = detailAction
        self.appIconPressAction = appIconPressAction
        self.tintColor = tintColor
    }

    enum Types {
        case standard
        case about
        case noInternet
        case update
    }

    let type: Types
    var title: String
    var label1: String?
    var label2: String?
    var mainButtonLabel: String?
    var detailButtonLabel: String?
    var mainAction: (() -> Void)?
    var detailAction: (() -> Void)?
    var appIconPressAction: (() -> Void)?
    var tintColor: Color
}

extension ModalViewModel {
    private static var version: String? {
        if let version = Bundle.main.releaseVersionNumberString {
            "Version \(version)"
        } else {
            nil
        }
    }

    private static var build: String? {
        if let build = Bundle.main.buildVersionNumberString {
            "Build \(build)"
        } else {
            nil
        }
    }

    private static var versionBuildString: String {
        [version, build].compactMap(\.self).joined(separator: "\n")
    }

    static var about: ModalViewModel {
        .init(
            type: .about,
            title: Bundle.main.displayName,
            label1: versionBuildString,
            label2: .init(localized: "DEVELOPED_BY:") + " " + .developerName
        )
    }
}

extension ModalViewModel {
    static var noInternet: ModalViewModel {
        let label2: String = if NetworkManager.shared.hasCellularCapabilities {
            .init(localized: "INTERNET_CONNECTION_REQUIRED_MESSAGE_2_WIFI/CELLULAR")
        } else {
            .init(localized: "INTERNET_CONNECTION_REQUIRED_MESSAGE_2_WIFI")
        }
        return .init(
            type: .noInternet,
            title: .init(localized: "INTERNET_CONNECTION_REQUIRED"),
            label1: .init(localized: "INTERNET_CONNECTION_REQUIRED_MESSAGE"),
            label2: label2,
            mainButtonLabel: .init(localized: "RETRY")
        )
    }
}

extension ModalViewModel {
    static func update(
        mainButtonAction: (() -> Void)? = nil,
        detailButtonAction: (() -> Void)? = nil
    ) -> ModalViewModel {
        .init(
            type: .update,
            title: .init(localized: "UPDATE_REQUIRED"),
            label1: .init(localized: "UPDATE_REQUIRED_LABEL_1"),
            label2: .init(localized: "UPDATE_REQUIRED_LABEL_2"),
            mainButtonLabel: .init(localized: "UPDATE_GO_TO_APP_STORE"),
            detailButtonLabel: .init(localized: "UPDATE_TURN_ON_AUTOMATIC_UPDATES"),
            mainAction: mainButtonAction,
            detailAction: detailButtonAction,
            tintColor: .accent
        )
    }
}
