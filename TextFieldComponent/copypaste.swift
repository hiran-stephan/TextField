// MARK: - Center assertions (unchanged)
private func centerIsFRM() -> Bool {
    guard let panelVC = RoutingHelper.getPanelFrame(),
          let center = panelVC.center else { return false }

    if let nav = center as? UINavigationController {
        return nav.topViewController is FRMWebViewWrapperController
    }
    if let nav = center.children.first(where: { $0 is UINavigationController }) as? UINavigationController {
        return nav.topViewController is FRMWebViewWrapperController
    }
    if center is FRMWebViewWrapperController { return true }
    return false
}

private func expectCenterToBeFRM(timeout: DispatchTimeInterval = .seconds(4)) {
    expect({ () -> Bool in centerIsFRM() }).toEventually(beTrue(), timeout: timeout)
}

// MARK: - OTC fakes to satisfy the mobile-only gate
final class FakeOTCKeyService: OTCKeyService {
    override func getPushOTVCRegisteredDeviceTag() -> String? {
        return "UNIT_TEST_DEVICE_TAG"
    }
}

// Convenience to install the fakes in the app container used by the router.
// If your project exposes these differently, adjust the two assignment lines.
private func installOTCMocksForTests() {
    // Your repo already has MockOTVCService (see screenshot)
    let mock = MockOTVCService()
    mock.getRegisteredDeviceSuccess = true
    // build the response that equals "device push enabled"
    var dto = RegisteredDeviceResponseDto()
    dto.status = .devicePushEnabled
    mock.mockRegisteredDeviceResponseDto = dto

    BKContainer.services.otcKeyService = FakeOTCKeyService()
    BKContainer.services.otcService    = mock
}

it("routeToFRMFraudReview") {
    // GIVEN: FRM required (not mobile-only), and app flagged as coming from Fraud Alert
    BKAppState.didActionFraudAlertNotification = true

    let actionItems = ActionItemRequiredFlagResponseDto(response: [
        "cdccRequired": false,
        "ccFraudReviewRequired": true
    ])!
    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItems)

    guard TabbarUtils.getTabbarViewController() != nil else {
        fail("Error: TabbarViewController"); return
    }

    // WHEN
    BKContainer.routing.actionItem.routeToActionItem()

    // THEN: FRM should be set as the center/root (not modally presented)
    expectCenterToBeFRM()
}


it("routeToFRMFraudReviewMobileOnly") {
    // GIVEN: Mobile-only FRM required + OTC device gates satisfied
    BKAppState.didActionFraudAlertNotification = true
    installOTCMocksForTests()          // <- CRITICAL for this path

    let actionItems = ActionItemRequiredFlagResponseDto(response: [
        "cdccRequired": false,
        "ccFraudReviewRequired": false,
        "fraudCaseReviewMobileOnlyRequired": true
    ])!
    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItems)

    guard TabbarUtils.getTabbarViewController() != nil else {
        fail("Error: TabbarViewController"); return
    }

    // WHEN
    BKContainer.routing.actionItem.routeToActionItem()

    // THEN
    expectCenterToBeFRM(timeout: .seconds(5)) // allow async OTC callback
}

