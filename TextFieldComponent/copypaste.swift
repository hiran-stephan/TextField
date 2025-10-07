// Add window.open handler here:
extension PlatformWebViewInterface: WKUIDelegate {
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {

        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
            if viewModel.loadAppPageWebView(url: url.absoluteString) == false {
                UIApplication.shared.open(url)
            } else {
                webView.load(URLRequest(url: url))
            }
        }
        return nil
    }
}
