//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import LinkPresentation
import SwiftUI
import UIKit

struct UIActivityView: UIViewControllerRepresentable {
    var name: String
    var url: URL
    var image: UIImage
    var excludedActivityTypes: [UIActivity.ActivityType] = []

    init(
        name: String,
        url: URL,
        image: UIImage,
        excludedActivityTypes: [UIActivity.ActivityType]
    ) {
        self.name = name
        self.url = url
        self.image = image
        self.excludedActivityTypes = excludedActivityTypes
    }

    func makeUIViewController(
        context: Context
    ) -> UIActivityViewController {
        let uiavc = UIActivityViewController(
            activityItems: [
                UIActivityElement(
                    title: name,
                    url: url,
                    image: image
                )
            ],
            applicationActivities: nil
        )
        uiavc.excludedActivityTypes = excludedActivityTypes
        return uiavc
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) { }
}

private class UIActivityElement: NSObject, UIActivityItemSource {
    var title: String
    var url: URL
    var image: UIImage

    init(title: String, url: URL, image: UIImage) {
        self.title = title
        self.url = url
        self.image = image
        super.init()
    }

    func activityViewControllerPlaceholderItem(
        _ activityViewController: UIActivityViewController
    ) -> Any {
        return url
    }

    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        return url
    }

    func activityViewController(
        _ activityViewController: UIActivityViewController,
        subjectForActivityType activityType: UIActivity.ActivityType?
    ) -> String {
        return title
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.iconProvider = NSItemProvider(object: image)
        metadata.originalURL = url
        return metadata
    }
}
