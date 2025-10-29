import ObjectiveC.runtime

// MARK: - assert "center is FRM"
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

private func expectCenterToBeFRM(timeout: DispatchTimeInterval = .seconds(4)) {
    expect({ centerIsFRM() }).toEventually(beTrue(), timeout: timeout)
}

// MARK: - Keychain tag helper (gate #1)
private func writeOTVCPushTagForTests() {
    // Your Obj-C keychain wrapper exposes these exactly:
    //  -setPushOTVCRegisteredDeviceTag:
    //  -getPushOTVCRegisteredDeviceTag
    CIBCKeyChain().setPushOTVCRegisteredDeviceTag("UNIT_TEST_DEVICE_TAG")
}

// MARK: - Swizzle OTCService (gate #2)
private var didSwizzleOTC = false

extension OTCService {
    // Signature must match the production method exactly
    @objc func _ut_getRegisteredPushOTVCDevice(
        _ completion: @escaping OTCVServiceCompletionHandler,
        registeredDeviceTag: String
    ) {
        // Satisfy the router with a "push enabled" response
        let dto = RegisteredDeviceResponseDto(
            response: ["status": DeviceRegistrationStatus.devicePushEnabled.rawValue]
        )
        completion(dto, nil)
    }
}

private func swizzleOTCIfNeeded() {
    guard !didSwizzleOTC else { return }
    let original = class_getInstanceMethod(
        OTCService.self,
        #selector(OTCService.getRegisteredPushOTVCDevice(_:registeredDeviceTag:))
    )
    let replacement = class_getInstanceMethod(
        OTCService.self,
        #selector(OTCService._ut_getRegisteredPushOTVCDevice(_:registeredDeviceTag:))
    )
    if let original = original, let replacement = replacement {
        method_exchangeImplementations(original, replacement)
        didSwizzleOTC = true
    } else {
        fail("Swizzle failed: could not find OTCService method")
    }
}


it("routeToFRMFraudReview") {
    // GIVEN: FRM required (not mobile-only)
    BKAppState.didActionFraudAlertNotification = true        // passes the first check
    writeOTVCPushTagForTests()                                // ensure deviceTag is non-nil
    swizzleOTCIfNeeded()                                      // force .devicePushEnabled

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

    // THEN: FRM is set as the center/root (not presented modally)
    expectCenterToBeFRM()
}

it("routeToFRMFraudReviewMobileOnly") {
    // GIVEN: FRM mobile-only path (requires device tag + OTC positive)
    BKAppState.didActionFraudAlertNotification = true
    writeOTVCPushTagForTests()
    swizzleOTCIfNeeded()

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
    expectCenterToBeFRM(timeout: .seconds(5)) // allow async hop
}




