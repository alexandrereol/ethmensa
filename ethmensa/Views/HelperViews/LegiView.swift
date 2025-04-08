//
//  Copyright © 2025 Alexandre Reol. All rights reserved.
//

import SafariServices
import SwiftUI
import UIKit
import WebKit

struct LegiView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) var scenePhase

    @State private var previousBrightness = CGFloat(1.0)

    var body: some View {
        NavigationStack {
            WebView(
                request: .init(
                    url: "https://eduapp.ethz.ch/eth-card".toURL()!
                )
            )
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationTitle("LEGI_CARD")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(uiColor: .secondarySystemBackground))
            .onAppear {
                setBrightness()
            }
            .onDisappear {
                restorePrevBrightness()
            }
            .onChange(of: scenePhase) { scenePhase in
                switch scenePhase {
                case .active:
                    setBrightness()
                case .inactive, .background:
                    restorePrevBrightness()
                @unknown default:
                    break
                }
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

    private func setBrightness() {
        previousBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = 1.0
    }

    private func restorePrevBrightness() {
        UIScreen.main.brightness = previousBrightness
    }
}

struct WebView: UIViewRepresentable {
    let request: URLRequest

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        webView.scrollView.delegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
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
                ".barcode-wrap {height: 70px !important}",
                ".barcode-wrap {padding-top: 20px !important}",
                "#main-content {margin: 0 !important}",
                "#main-content {background: \(backgroundColor) !important}",
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

        func scrollViewWillBeginZooming(
            _ scrollView: UIScrollView,
            with view: UIView?
        ) {
            scrollView.pinchGestureRecognizer?.isEnabled = false
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
    Text(String("Hello World!"))
        .sheet(isPresented: .constant(true)) {
            LegiView()
        }
}
