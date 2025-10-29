// MARK: - FRM presence under center (recursive)
private func containsFRMWebView(_ vc: UIViewController) -> Bool {
    // Direct hit
    if vc is FRMWebViewController { return true }

    // UINavigationController case
    if let nav = vc as? UINavigationController {
        if nav.viewControllers.contains(where: { $0 is FRMWebViewController }) { return true }
        if let top = nav.topViewController, containsFRMWebView(top) { return true }
    }

    // UITabBarController case
    if let tab = vc as? UITabBarController {
        if let selected = tab.selectedViewController, containsFRMWebView(selected) { return true }
        if tab.viewControllers?.contains(where: { containsFRMWebView($0) }) == true { return true }
    }

    // CIBC custom TabViewController (like your CIBC.TabViewController)
    // these usually have a single child that’s a UINavigationController
    if String(describing: type(of: vc)).contains("TabViewController") {
        for child in vc.children {
            if containsFRMWebView(child) { return true }
        }
    }

    // Generic children
    for child in vc.children {
        if containsFRMWebView(child) { return true }
    }

    return false
}

private func centerHasFRMWebView() -> Bool {
    guard let panel = RoutingHelper.getPanelFrame(),
          let center = panel.center else { return false }
    return containsFRMWebView(center)
}

private func expectCenterToContainFRM(timeout: DispatchTimeInterval = .seconds(8)) {
    expect({ centerHasFRMWebView() }).toEventually(beTrue(), timeout: timeout)
}

it("routeToFRMFraudReview") {
    BKAppState.didActionFraudAlertNotification = true
    writeOTVCPushTagForTests()
    swizzleOTCIfNeeded()

    let items = ActionItemRequiredFlagResponseDto(response: [
        "cdccRequired": false,
        "ccFraudReviewRequired": true
    ])!
    BKServiceCache.shared.setCachedActionItemRequiredFlag(items)

    guard TabbarUtils.getTabbarViewController() != nil else {
        fail("Error: TabbarViewController"); return
    }

    BKContainer.routing.actionItem.routeToActionItem()

    expectCenterToContainFRM()  // <— new assertion
}

it("routeToFRMFraudReviewMobileOnly") {
    BKAppState.didActionFraudAlertNotification = true
    writeOTVCPushTagForTests()
    swizzleOTCIfNeeded()

    let items = ActionItemRequiredFlagResponseDto(response: [
        "cdccRequired": false,
        "ccFraudReviewRequired": false,
        "fraudCaseReviewMobileOnlyRequired": true
    ])!
    BKServiceCache.shared.setCachedActionItemRequiredFlag(items)

    guard TabbarUtils.getTabbarViewController() != nil else {
        fail("Error: TabbarViewController"); return
    }

    BKContainer.routing.actionItem.routeToActionItem()

    expectCenterToContainFRM(timeout: .seconds(8))
}
