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



<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Phone Link Test</title>
<style>
  body { font-family: -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Arial; padding: 20px; }
  .btn { display: block; margin: 12px 0; padding: 12px 16px; border-radius: 10px;
         background:#c00; color:#fff; text-decoration:none; width:max-content }
  .btn.secondary { background:#444; }
  small { color:#666 }
</style>
<script>
  function openTelViaJS() {
    // This should trigger decidePolicyFor with targetFrame == null on iOS 18+ (popup-style open)
    window.open('tel:+18774486500', '_blank');  // try _blank first
    // Fallback:
    // window.location.href = 'tel:+18774486500';
  }
</script>
</head>
<body>

<h2>Phone Link Repro</h2>
<p><small>Number: +1 (877) 448-6500 (CIBC USA Help Center)</small></p>

<!-- Plain tel: -->
<a class="btn" data-test-id="call-plain" aria-label="Call (plain)"
   href="tel:+18774486500">Call (plain tel:)</a>

<!-- target=_self -->
<a class="btn" data-test-id="call-self" aria-label="Call (target self)"
   href="tel:+18774486500" target="_self">Call (target="_self")</a>

<!-- target=_blank (no target frame -> your WK delegate should intercept) -->
<a class="btn" data-test-id="call-blank" aria-label="Call (target blank)"
   href="tel:+18774486500" target="_blank" rel="noopener">Call (target="_blank")</a>

<!-- JS window.open('tel:...') -->
<button class="btn secondary" data-test-id="call-window-open" aria-label="Call via JS"
        onclick="openTelViaJS()">Call (window.open)</button>

<!-- FaceTime Audio (useful on iPad that can’t dial tel:) -->
<a class="btn" data-test-id="facetime-audio" aria-label="Call via FaceTime Audio"
   href="facetime-audio://+18774486500">FaceTime Audio (fallback)</a>

<hr/>
<p>
  Expected behaviors:
  <ul>
    <li><code>plain</code> and <code>_self</code>: should reach your delegate; if intercepted and cancelled, you should call <code>UIApplication.shared.open</code>.</li>
    <li><code>_blank</code> and <code>window.open</code>: create a new window → <code>navigationAction.targetFrame == nil</code>. Your delegate should cancel and handle externally.</li>
    <li>On iPad Wi-Fi: <code>tel:</code> may not be handled → test your FaceTime Audio fallback.</li>
  </ul>
</p>

</body>
</html>
