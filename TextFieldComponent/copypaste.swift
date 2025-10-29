private func centerIsFRM() -> Bool {
    guard let panelVC = RoutingHelper.getPanelFrame(),
          let center = panelVC.center else { return false }

    // Case 1: center is a UINavigationController with FRM on top
    if let nav = center as? UINavigationController {
        return nav.topViewController is FRMWebViewWrapperController
    }

    // Case 2: center has a child UINavigationController with FRM on top
    if let nav = center.children.first(where: { $0 is UINavigationController }) as? UINavigationController {
        return nav.topViewController is FRMWebViewWrapperController
    }

    // Case 3: center is directly FRM
    if center is FRMWebViewWrapperController {
        return true
    }

    return false
}

private func expectCenterToBeFRM(timeout: DispatchTimeInterval = .seconds(3)) {
    // The closure must return a Bool for Nimble to evaluate repeatedly
    expect({ () -> Bool in
        return centerIsFRM()
    }).toEventually(beTrue(), timeout: timeout)
}



it("routeToFRMFraudReview") {
    // GIVEN
    let actionItems = ActionItemRequiredFlagResponseDto(
        response: [
            "cdccRequired": false,
            "ccFraudReviewRequired": true
        ]
    )!
    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItems)

    guard let tabbarVC = TabbarUtils.getTabbarViewController() else {
        fail("Error: TabbarViewController")
        return
    }

    // WHEN
    BKContainer.routing.actionItem.routeToActionItem()

    // THEN
    expectCenterToBeFRM()
}


it("routeToFRMFraudReviewMobileOnly") {
    // GIVEN
    let actionItems = ActionItemRequiredFlagResponseDto(
        response: [
            "cdccRequired": false,
            "ccFraudReviewRequired": false,
            "fraudCaseReviewMobileOnlyRequired": true
        ]
    )!
    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItems)

    guard let tabbarVC = TabbarUtils.getTabbarViewController() else {
        fail("Error: TabbarViewController")
        return
    }

    // WHEN
    BKContainer.routing.actionItem.routeToActionItem()

    // THEN
    expectCenterToBeFRM()
}
