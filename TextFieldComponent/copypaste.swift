it("routeToFRMFraudReview clears fraud flags in cache") {
    // Given: only fraudCaseReviewRequired is true
    let actionItems = ActionItemRequiredFlagResponseDto(response: [
        "cdcRequired": false,
        "ccFraudReviewRequired": false,
        "fraudCaseReviewRequired": true,
        "fraudCaseReviewMobileOnlyRequired": false,
        "investmentKycReviewDue": false
    ])
    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItems)

    // When
    if let tabbarVC = TabbarUtils.getTabbarViewController() {
        let presentedViewController = verifyPresentedViewController(sut: tabbarVC)
        BKContainer.routing.actionItem.routeToActionItem()

        // Then – FRM fraud review flow still presented as before
        if let wrapperVC = presentedViewController as? FRMWebViewWrapperViewController {
            wrapperVC.loadViewIfNeeded()
            let navVC = wrapperVC.children.filter({ $0 is UINavigationController }).first as? UINavigationController
            expect(navVC?.viewControllers.count).to(equal(1))
        } else {
            fail("Error: FRMWebViewWrapperController")
        }
    } else {
        fail("Error: TabbarViewController")
    }

    // And: fraud flags in cache are cleared
    let cached = BKServiceCache.shared.getCachedActionItemRequiredFlag()
    expect(cached?.fraudCaseReviewRequired).to(beFalse())
    expect(cached?.fraudCaseReviewMobileOnlyRequired).to(beFalse())
}

it("routeToFRMFraudReviewMobileOnly clears fraud flags in cache") {
    // Given: only fraudCaseReviewMobileOnlyRequired is true
    let actionItems = ActionItemRequiredFlagResponseDto(response: [
        "cdcRequired": false,
        "ccFraudReviewRequired": false,
        "fraudCaseReviewRequired": false,
        "fraudCaseReviewMobileOnlyRequired": true,
        "investmentKycReviewDue": false
    ])
    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItems)

    // When
    if let tabbarVC = TabbarUtils.getTabbarViewController() {
        let presentedViewController = verifyPresentedViewController(sut: tabbarVC)
        BKContainer.routing.actionItem.routeToActionItem()

        // Then – FRM fraud review flow still presented as before
        if let wrapperVC = presentedViewController as? FRMWebViewWrapperViewController {
            wrapperVC.loadViewIfNeeded()
            let navVC = wrapperVC.children.filter({ $0 is UINavigationController }).first as? UINavigationController
            expect(navVC?.viewControllers.count).to(equal(1))
        } else {
            fail("Error: FRMWebViewWrapperController")
        }
    } else {
        fail("Error: TabbarViewController")
    }

    // And: fraud flags in cache are cleared
    let cached = BKServiceCache.shared.getCachedActionItemRequiredFlag()
    expect(cached?.fraudCaseReviewRequired).to(beFalse())
    expect(cached?.fraudCaseReviewMobileOnlyRequired).to(beFalse())
}
