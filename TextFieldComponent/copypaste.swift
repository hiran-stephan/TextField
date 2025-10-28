//
//  PushNotificationsManager+FraudReviewPushNotificationHandler.swift
//  MobileBanking
//
//  Created by Hiran on 2025-10-28.
//

import Foundation
import UserNotifications
import UIKit
import BankKit

// MARK: - Public surface (kept small on purpose)
extension PushNotificationsManager {

    /// Quick filter you can reuse in unit tests and call-sites.
    /// Returns true if the payload should be handled by the FRM pipeline.
    func isFraudReviewNotification(_ userInfo: [AnyHashable: Any]) -> Bool {
        guard let channel = channelId(from: userInfo) else { return false }
        return channel.uppercased() == "FRAUDALERT"
    }

    /// Entrypoint used by notification callbacks. Handles foreground,
    /// background (tap), and optional pre-login vs post-login differences.
    ///
    /// - Parameters:
    ///   - userInfo: APNS payload
    ///   - cameFromUserTap: true if invoked from `didReceive response` (user tapped banner/lock screen)
    ///   - applicationState: pass `UIApplication.shared.applicationState`
    func handleFraudReviewPush(
        userInfo: [AnyHashable: Any],
        cameFromUserTap: Bool,
        applicationState: UIApplication.State
    ) {
        // Feature flag gate
        guard FeatureHelper.hasFraudReviewEnabled() else { return }

        // Foreground: you may want to show a banner-style modal immediately
        if applicationState == .active {
            presentFRMInterruptionModal {
                self.routeToFRM(with: userInfo)
            }
            return
        }

        // Background / suspended -> came via user tap.
        if cameFromUserTap {
            // Post sign-on path shows native interruption modal first (per HLD),
            // then CTA routes to FRM webview. If not logged in, go through your hijack flow.
            if ApplicationSettings.isApplicationLoggedIn() {
                presentFRMInterruptionModal {
                    self.routeToFRM(with: userInfo)
                }
            } else {
                // Pre sign-on: preserve existing sign-on hijack logic.
                // Option A: stash the payload to process after login:
                ThreeDSPushNotificationHandler.shared.reset() // example: clean any prior state
                FRMPushContext.shared.storePendingUserInfo(userInfo)
                BKRoute.routeToSignInViewControllerWhenFeatureIsEnabled()
                // Your login success hook should call `FRMPushContext.shared.consumeIfPending(...)`
            }
        }
    }
}

// MARK: - Private helpers
private extension PushNotificationsManager {

    func routeToFRM(with userInfo: [AnyHashable: Any]) {
        // If you need to enrich headers with x-device-tag, ensure your web adapter
        // already injects it for the FRM URL (appconfig `webview_url_digital_frm`).
        // Otherwise, add your header injection hook there.
        BKContainer.routing.routeToFRMFraudReviewWebView()
        // Optional: analytics
        PushNotificationUtil.handlePushNotificationAnalytics(userInfo: userInfo)
    }

    func presentFRMInterruptionModal(onConfirm: @escaping () -> Void) {
        DispatchQueue.main.async {
            let title   = NSLocalizedString("frm_alert_title", comment: "Suspicious activity on your account")
            let message = NSLocalizedString("frm_alert_message",
                                            comment: "We need you to review this in a secure view.")
            let ok      = NSLocalizedString("frm_alert_cta_review_now", comment: "Review now")
            let later   = NSLocalizedString("frm_alert_cta_not_now",   comment: "Not now")

            // If you have a house alert presenter, use it here instead of UIKit.
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: later, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: ok, style: .default, handler: { _ in onConfirm() }))

            if let top = Self.topMostViewController() {
                // Avoid double-present if already showing something
                if top.presentedViewController == nil || !(top.presentedViewController is UIAlertController) {
                    top.present(alert, animated: true)
                }
            }
        }
    }

    static func topMostViewController(_ base: UIViewController? = UIApplication.shared
        .connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController { return topMostViewController(nav.visibleViewController) }
        if let tab = base as? UITabBarController, let sel = tab.selectedViewController { return topMostViewController(sel) }
        if let presented = base?.presentedViewController { return topMostViewController(presented) }
        return base
    }

    // Reuse the same tiny helper you started with.
    func channelId(from userInfo: [AnyHashable: Any]) -> String? {
        if let id = userInfo["channelId"] as? String { return id }
        if let id = userInfo["channeld"] as? String { return id } // safety if backend typo occurs
        return nil
    }
}

// MARK: - Optional: persist FRM payload until login completes
final class FRMPushContext {
    static let shared = FRMPushContext()
    private var pending: [AnyHashable: Any]?

    func storePendingUserInfo(_ userInfo: [AnyHashable: Any]) { pending = userInfo }

    /// Call this after successful login (e.g., from your login success hook)
    func consumeIfPending(_ handler: ( [AnyHashable: Any] ) -> Void ) {
        guard let p = pending else { return }
        pending = nil
        handler(p)
    }
}




func userNotificationCenter(_ center: UNUserNotificationCenter,
                            didReceive response: UNNotificationResponse,
                            withCompletionHandler completionHandler: @escaping () -> Void) {

    let userInfo = response.notification.request.content.userInfo

    // >>> Add these 3 lines at the top
    if PushNotificationsManager.shared.isFraudReviewNotification(userInfo) {
        PushNotificationsManager.shared.handleFraudReviewPush(
            userInfo: userInfo,
            cameFromUserTap: true,
            applicationState: UIApplication.shared.applicationState
        )
        completionHandler()
        return
    }
    // <<< end add

    // Existing paths (Braze, 3DS, etc.)
    PushNotificationUtil.handlePushNotificationAction(
        pushUserInfo: userInfo,
        actionIdentifier: response.actionIdentifier
    )
    completionHandler()
}




if PushNotificationsManager.shared.isFraudReviewNotification(notification.request.content.userInfo) {
    PushNotificationsManager.shared.handleFraudReviewPush(
        userInfo: notification.request.content.userInfo,
        cameFromUserTap: false,
        applicationState: .active
    )
    completionHandler([]) // we’re showing our own modal; suppress system banner
    return
}



