//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SafariServices
import SwiftUI
import UIKit
import WebKit

struct LegiView: View {

    @Environment(\.dismiss) var dismiss

    @State private var previousBrightness = CGFloat(1.0)

    var body: some View {
        NavigationStack {
            WebView(
                request: .init(
                    url: "https://eduapp.ethz.ch/eth-card".toURL()!
                )
            )
            .disabled(true)
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationTitle("LEGI_CARD")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(uiColor: .secondarySystemBackground))
            .onAppear {
                previousBrightness = UIScreen.main.brightness
                UIScreen.main.brightness = 1.0
            }
            .onDisappear {
                UIScreen.main.brightness = previousBrightness
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("CLOSE") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let request: URLRequest

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {

        func webView(
            _ webView: WKWebView,
            didFinish navigation: WKNavigation!
        ) {
            let foregroundColor = UIColor.label.toHexString()
            let backgroundColor = UIColor.secondarySystemBackground.toHexString()
            let css = [
                ".modal {visibility: hidden !important}",
                ".header {visibility: hidden !important}",
                ".sidebar {visibility: hidden !important}",
                "#eth-card-display {background: white;}",
                "#main-content {margin: 0 !important;background: \(backgroundColor) !important}",
                "#app {background: \(backgroundColor)}",
                ".layout {background: \(backgroundColor)}",
                ".time-display.date-time {color: \(foregroundColor) !important}",
                ".bottom-text-wrap {color: \(foregroundColor) !important}"
            ].joined(separator: "")
            let jsc = [
                "var style = document.createElement('style');",
                "style.innerHTML = '\(css)';",
                "document.head.appendChild(style);"
            ].joined(separator: "")
            webView.evaluateJavaScript(jsc, completionHandler: nil)
        }
    }
}

private extension UIColor {
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        return String(format: "#%06x", rgb)
    }
}

#Preview {
    Text("Hello World!")
        .sheet(isPresented: .constant(true)) {
            LegiView()
        }
}
