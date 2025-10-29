// ─────────────────────────────────────────────────────────────────────────────
// Helper: assert that the center panel (not a modal) is the FRM webview route
// ─────────────────────────────────────────────────────────────────────────────
private func centerIsFRM() -> Bool {
    guard let panelVC = RoutingHelper.getPanelFrame(), let center = panelVC.center else {
        return false
    }

    // Center is a UINavigationController with FRM on top
    if let nav = center as? UINavigationController {
        return nav.topViewController is FRMWebViewWrapperController
    }

    // Center is a container whose first child is a nav with FRM on top
    if let nav = center.children.first(where: { $0 is UINavigationController }) as? UINavigationController {
        return nav.topViewController is FRMWebViewWrapperController
    }

    // Center is directly the FRM wrapper
    if center is FRMWebViewWrapperController {
        return true
    }

    return false
}

private func expectCenterToBeFRM(timeout: DispatchTimeInterval = .seconds(2)) {
    expect({ centerIsFRM() }).toEventually(beTrue(), timeout: timeout)
}


it("routeToFRMFraudReview") {
    // GIVEN: flags that require FRM fraud review
    let actionItems = ActionItemRequiredFlagResponseDto(
        response: [
            "cdccRequired": false,
            "ccFraudReviewRequired": true
        ]
    )!
    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItems)

    // Sanity: we have a tab bar to route from
    guard let tabbarVC = TabbarUtils.getTabbarViewController() else {
        fail("Error: TabbarViewController")
        return
    }

    // WHEN: we route
    _ = verifyPresentedViewController(sut: tabbarVC)  // keeps the same setup path if needed, but not used
    BKContainer.routing.actionItem.routeToActionItem()

    // THEN: FRM is set as the center/root (not presented modally)
    expectCenterToBeFRM()
}


it("routeToFRMFraudReviewMobileOnly") {
    // GIVEN: flags that require the FRM Mobile-Only flow
    let actionItems = ActionItemRequiredFlagResponseDto(
        response: [
            "cdccRequired": false,
            "ccFraudReviewRequired": false,
            "fraudCaseReviewMobileOnlyRequired": true
        ]
    )!
    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItems)

    // Sanity: we have a tab bar to route from
    guard let tabbarVC = TabbarUtils.getTabbarViewController() else {
        fail("Error: TabbarViewController")
        return
    }

    // WHEN
    _ = verifyPresentedViewController(sut: tabbarVC)  // optional; keeps any test harness side-effects
    BKContainer.routing.actionItem.routeToActionItem()

    // THEN
    expectCenterToBeFRM()
}
