// Put near top of the spec file (test-only)
final class FeatureHelperStub: FeatureHelperProtocol {
    var fraudReviewEnabled = true
    var fraudOptimizedEnabled = true

    func hasFraudReviewEnabled() -> Bool { fraudReviewEnabled }
    func hasFraudOptimizedEnabled() -> Bool { fraudOptimizedEnabled }

    // If your FeatureHelper has other methods, either no-op or default them:
    func hasFeatureEnabled(feature: FeatureFlag) -> Bool { true }
}

// Helper to install the stub into your DI singletons
private func installFeatureHelperStub(
    fraudReview: Bool = true,
    fraudOptimized: Bool = true
) -> FeatureHelperStub {
    let stub = FeatureHelperStub()
    stub.fraudReviewEnabled = fraudReview
    stub.fraudOptimizedEnabled = fraudOptimized
    BKContainer.featureHelper = stub   // ⬅️ replace with your actual DI assignment
    return stub
}


// Protocols are inferred; rename to your actual ones if needed.
final class OTVCSKeyChainStub: OTVCSKeyChain {
    var tag: String? = "TEST_TAG"
    override func getPushOTVCRegisteredDeviceTag() -> String? {
        return tag
    }
}

final class OTVCServiceStub: OTVCServiceProtocol {
    func getRegisteredPushOTVCDevice(
        _ tag: String,
        completion: @escaping (OTVCRegisteredDeviceResponse) -> Void
    ) {
        // Return an enabled status immediately
        completion(OTVCRegisteredDeviceResponse(status: .devicePushEnabled))
    }
}

// Helper to install both into your DI
private func installOTVCStubs() {
    BKContainer.routing.frm.otvcService = OTVCServiceStub()   // ⬅️ your DI path
    BKContainer.routing.frm.otvcKeychain = OTVCSKeyChainStub()// ⬅️ if accessed via DI
}


private func centerIsFRM() -> Bool {
    guard let panelVC = RoutingHelper.getPanelFrame(),
          let center = panelVC.center else { return false }

    if let nav = center as? UINavigationController {
        return nav.topViewController is FRMWebViewWrapperController
    }
    if let nav = center.children.first(where: { $0 is UINavigationController }) as? UINavigationController {
        return nav.topViewController is FRMWebViewWrapperController
    }
    return center is FRMWebViewWrapperController
}

private func expectCenterToBeFRM(timeout: DispatchTimeInterval = .seconds(3)) {
    expect({ () -> Bool in centerIsFRM() }).toEventually(beTrue(), timeout: timeout)
}



it("routeToFRMFraudReview") {
    // GIVEN
    installFeatureHelperStub(fraudReview: true, fraudOptimized: true)
    let actionItems = ActionItemRequiredFlagResponseDto(
        response: [
            "cdccRequired": false,
            "ccFraudReviewRequired": true
        ]
    )!
    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItems)

    // Ensure we’re in a normal segment (not excluded)
    let signOnDataResponse = SignOnResponseDto(response: ["segment": "personalBanking"])!
    BKServiceCache.shared.setCachedSignOnData(signOnDataResponse)

    guard TabbarUtils.getTabbarViewController() != nil else {
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
    installFeatureHelperStub(fraudReview: true, fraudOptimized: true)
    installOTVCStubs() // <- makes the device check pass

    let actionItems = ActionItemRequiredFlagResponseDto(
        response: [
            "cdccRequired": false,
            "ccFraudReviewRequired": false,
            "fraudCaseReviewMobileOnlyRequired": true
        ]
    )!
    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItems)

    let signOnDataResponse = SignOnResponseDto(response: ["segment": "personalBanking"])!
    BKServiceCache.shared.setCachedSignOnData(signOnDataResponse)

    guard TabbarUtils.getTabbarViewController() != nil else {
        fail("Error: TabbarViewController")
        return
    }

    // WHEN
    BKContainer.routing.actionItem.routeToActionItem()

    // THEN
    expectCenterToBeFRM()
}


