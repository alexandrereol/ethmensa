//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import Foundation

extension URL {
    /// A computed property that generates a URL for the App Store review page of the app.
    /// 
    /// This property constructs a URL that directs the user to the App Store page for the app,
    /// specifically to the section where they can write a review. The URL is constructed using
    /// the app's unique identifier (`appId`), and a query item is added to specify the action
    /// of writing a review.
    /// 
    /// - Returns: An optional `URL` object pointing to the App Store review page, or `nil` if the URL could not be
    /// constructed.
    static var getAppStoreReviewURL: URL? {
        guard let url = "itms-apps://apps.apple.com/app/id\(String.appId)".toURL() else {
            return nil
        }
        var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )
        components?.queryItems = [
            URLQueryItem(
                name: "action",
                value: "write-review"
            )
        ]
        return components?.url
    }
}
