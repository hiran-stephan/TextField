private enum PushChannel: String {
    case fraudAlert = "FRAUDALERT"
}

private func channelId(from userInfo: [AnyHashable: Any]) -> String? {
    // Common places: "channelId", "channeldId", or nested in "extras"
    if let id = userInfo["channelId"] as? String { return id }
    if let extras = userInfo["extras"] as? [String: Any],
       let id = extras["channelId"] as? String { return id }
    return nil
}

let userInfo = response.notification.request.content.userInfo

   if let ch = channelId(from: userInfo),
      ch == PushChannel.fraudAlert.rawValue,
      FeatureHelper.hasFraudReviewEnabled(),                // you already added this helper
      ApplicationSettings.isApplicationLoggedIn() {         // your existing login check

       presentFRMInterruptionModal(userInfo: userInfo)      // <-- implement below
       completionHandler()
       return
   }

private func presentFRMInterruptionModal(userInfo: [AnyHashable: Any]) {
    let title = "Suspicious activity on your account" // pull from copy deck/localization
    let message = "We have to stop your process. Tap Continue to review and secure your account." // short placeholder

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    // Primary CTA → route to FRM webview (post sign-on)
    let continueAction = UIAlertAction(title: "Continue", style: .default) { _ in
        // If you need x-device-tag, fetch from Keychain before routing:
        // let tag = CIBCKeyChain.getPushOTVCRegisteredDeviceTag()
        // pass via your WebView header injector (already part of your FRM module)
        BKContainer.routing.routeToFRMFraudReviewWebView()
    }

    // Optional secondary action
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

    alert.addAction(continueAction)
    alert.addAction(cancelAction)

    DispatchQueue.main.async {
        self.topMostViewController()?.present(alert, animated: true, completion: nil)
    }
}

// Utility to get a presenter
private func topMostViewController(base: UIViewController? = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController { return topMostViewController(base: nav.visibleViewController) }
    if let tab = base as? UITabBarController { return topMostViewController(base: tab.selectedViewController) }
    if let presented = base?.presentedViewController { return topMostViewController(base: presented) }
    return base
}


private func presentFRMInterruptionModal(userInfo: [AnyHashable: Any]) {
    let title = "Suspicious activity on your account" // pull from copy deck/localization
    let message = "We have to stop your process. Tap Continue to review and secure your account." // short placeholder

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    // Primary CTA → route to FRM webview (post sign-on)
    let continueAction = UIAlertAction(title: "Continue", style: .default) { _ in
        // If you need x-device-tag, fetch from Keychain before routing:
        // let tag = CIBCKeyChain.getPushOTVCRegisteredDeviceTag()
        // pass via your WebView header injector (already part of your FRM module)
        BKContainer.routing.routeToFRMFraudReviewWebView()
    }

    // Optional secondary action
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

    alert.addAction(continueAction)
    alert.addAction(cancelAction)

    DispatchQueue.main.async {
        self.topMostViewController()?.present(alert, animated: true, completion: nil)
    }
}

// Utility to get a presenter
private func topMostViewController(base: UIViewController? = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController { return topMostViewController(base: nav.visibleViewController) }
    if let tab = base as? UITabBarController { return topMostViewController(base: tab.selectedViewController) }
    if let presented = base?.presentedViewController { return topMostViewController(base: presented) }
    return base
}



