// --- Feature flag test toggles (adjust to your project’s helper) ---
private func enableFraudFlagsForTests() {
    // Try the most common hooks; if your project exposes different ones,
    // replace these with your actual helpers.
    FeatureHelper.setFraudReviewEnabledForTests?(true)
    FeatureHelper.setFraudOptimizationEnabledForTests?(true)

    // Fallbacks that many codebases have:
    BKContainer.featureHelper?.enable?(.fraudReview)
    BKContainer.featureHelper?.enable?(.fraudOptimization)

    // If none of the above exist in your codebase, add one of these
    // test-only extension shims in your test target:
    //   extension FeatureHelper { static var _fraudReviewOverride = true ... }
}

// --- Mobile-only stubs: make the device check pass synchronously ---
class FakeOTCKeyService: OTCKeyService {
    override func getPushOTVCRegisteredDeviceTag() -> String? { "TEST_TAG" }
}

class FakeOTCService: OTCService {
    override func getRegisteredPushOTVCDevice(_ tag: String,
                                              completion: @escaping (RegisteredDeviceResponse) -> Void) {
        // Immediately say "push enabled" so routing proceeds to FRM
        completion(RegisteredDeviceResponse(status: .devicePushEnabled))
    }
}

// Wire the fakes into whatever your app uses as a service locator.
// Adjust these two assignment lines to match your container:
private func installOTCFakes() {
    BKContainer.services.otcKeyService = FakeOTCKeyService()
    BKContainer.services.otcService    = FakeOTCService()
}

it("routeToFRMFraudReview") {
    // GIVEN
    enableFraudFlagsForTests()
    BKAppState.didActionFraudAlertNotification = true    // satisfies the first gate, if used

    let actionItems = ActionItemRequiredFlagResponseDto(
        response: [
            "cdccRequired": false,
            "ccFraudReviewRequired": true
        ]
    )!
    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItems)

    guard TabbarUtils.getTabbarViewController() != nil else {
        fail("Error: TabbarViewController"); return
    }

    // WHEN
    BKContainer.routing.actionItem.routeToActionItem()

    // THEN
    expectCenterToBeFRM(timeout: .seconds(3))
}


it("routeToFRMFraudReviewMobileOnly") {
    // GIVEN
    enableFraudFlagsForTests()
    installOTCFakes()                                   // <- critical for mobile-only path
    BKAppState.didActionFraudAlertNotification = true   // satisfies the first gate, if used

    let actionItems = ActionItemRequiredFlagResponseDto(
        response: [
            "cdccRequired": false,
            "ccFraudReviewRequired": false,
            "fraudCaseReviewMobileOnlyRequired": true
        ]
    )!
    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItems)

    guard TabbarUtils.getTabbarViewController() != nil else {
        fail("Error: TabbarViewController"); return
    }

    // WHEN
    BKContainer.routing.actionItem.routeToActionItem()

    // THEN
    expectCenterToBeFRM(timeout: .seconds(5))           // allow time for async callback
}
