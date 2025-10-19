// MARK: - Helpers

private func openPhoneURL(_ url: URL) {
    let app = UIApplication.shared

    // Try native phone first (works on iPhone; some iPads with Continuity may still handle it)
    if app.canOpenURL(url) {
        app.open(url)
        return
    }

    // iPad fallback: try FaceTime Audio
    // Add "facetime-audio" to LSApplicationQueriesSchemes in Info.plist for canOpenURL to work:
    // <key>LSApplicationQueriesSchemes</key>
    // <array>
    //   <string>facetime-audio</string>
    // </array>
    let digits = url.absoluteString.filter(\.isNumber)
    if let ft = URL(string: "facetime-audio://\(digits)"), app.canOpenURL(ft) {
        app.open(ft)
        return
    }

    // Final fallback: show a friendly message (or copy number)
    viewModel.checkNetworkAndDisplayError(message: "This device can't place calls. Number: +\(digits)")
}

private func handleExternalURL(_ url: URL) {
    let scheme = (url.scheme ?? "").lowercased()
    switch scheme {
    case "tel", "telprompt":
        openPhoneURL(url)
    case "sms", "mailto":
        UIApplication.shared.open(url)
    default:
        UIApplication.shared.open(url) // generic external link
    }
}

// MARK: - WKNavigationDelegate

func webView(_ webView: WKWebView,
             decidePolicyFor navigationAction: WKNavigationAction,
             decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

    guard let url = navigationAction.request.url else {
        decisionHandler(.allow)
        return
    }

    let scheme = (url.scheme ?? "").lowercased()

    // 1) Special schemes
    if ["tel", "telprompt", "sms", "mailto"].contains(scheme) {
        decisionHandler(.cancel)
        handleExternalURL(url)
        return
    }

    // 2) Handle target="_blank" (no target frame => WKWebView won’t navigate)
    if navigationAction.targetFrame == nil {
        decisionHandler(.cancel)
        handleExternalURL(url)
        return
    }

    // your existing allow/deny logic (domain checks etc.)
    if viewModel.loadOnPageWebViewUrl(url: url.absoluteString) {
        decisionHandler(.cancel)
        return
    }

    decisionHandler(.allow)
}
