import ObjectiveC.runtime

// MARK: - Captured navigation
private struct CapturedNav {
    var enumName: String?
    var navigationName: String?
    var optionIsSetAsRoot: Bool = false
}
private var _lastCapturedNav = CapturedNav()
private var _didSwizzleNavigate = false

// MARK: - Swizzle UIViewController.navigate to capture calls
extension UIViewController {
    // Matches your extension signature
    @objc func _ut_navigate(
        enumName: String,
        navigationName: String,
        option: NavigationOption,
        param: Any?,
        moduleChanged: Bool
    ) {
        // record
        _lastCapturedNav.enumName = enumName
        _lastCapturedNav.navigationName = navigationName
        _lastCapturedNav.optionIsSetAsRoot = {
            if case .setAsRoot = option { return true }
            return false
        }()

        // no-op: we intentionally DO NOT call the original here
        // to avoid side-effects / storyboard loads in unit tests.
    }
}

private func installNavigateSpyOnce() {
    guard !_didSwizzleNavigate else { return }
    guard
        let orig = class_getInstanceMethod(
            UIViewController.self,
            NSSelectorFromString("navigateWithEnumName:navigationName:option:param:moduleChanged:")
        ),
        let repl = class_getInstanceMethod(
            UIViewController.self,
            #selector(UIViewController._ut_navigate(enumName:navigationName:option:param:moduleChanged:))
        )
    else { fatalError("Failed to swizzle UIViewController.navigate(...)") }
    method_exchangeImplementations(orig, repl)
    _didSwizzleNavigate = true
}

// Convenience asserts
private func expectLastNav(toBe enumName: String, name: String, setAsRoot: Bool = true) {
    expect(_lastCapturedNav.enumName) == enumName
    expect(_lastCapturedNav.navigationName) == name
    expect(_lastCapturedNav.optionIsSetAsRoot) == setAsRoot
}

// MARK: - Gates used by router (only needed for mobile-only test)
private func writeOTVCPushTagForTests() { CIBCKeyChain.setPushOTVCRegisteredDeviceTag("UNIT_TEST_DEVICE_TAG") }

private var didSwizzleOTC = false
extension OTCService {
    @objc func _ut_getRegisteredPushOTVCDevice(
        _ completion: @escaping OTCServiceCompletionHandler,
        registeredDeviceTag: String
    ) {
        let dto = RegisteredDeviceResponseDto(
            response: ["status": DeviceRegistrationStatus.devicePushEnabled.rawValue]
        )
        completion(dto, nil)
    }
}
private func swizzleOTCIfNeeded() {
    guard !didSwizzleOTC else { return }
    guard
        let o = class_getInstanceMethod(OTCService.self,
            #selector(OTCService.getRegisteredPushOTVCDevice(_:registeredDeviceTag:))),
        let r = class_getInstanceMethod(OTCService.self,
            #selector(OTCService._ut_getRegisteredPushOTVCDevice(_:registeredDeviceTag:)))
    else { fatalError("OTC swizzle failed") }
    method_exchangeImplementations(o, r)
    didSwizzleOTC = true
}



it("routes to FRMFraudReview via FRMWebviewNavigation (setAsRoot)") {
    installNavigateSpyOnce()
    _lastCapturedNav = CapturedNav()

    // GIVEN
    BKAppState.didActionFraudAlertNotification = true
    let items = ActionItemRequiredFlagResponseDto(response: [
        "cdccRequired": false,
        "ccFraudReviewRequired": true
    ])!
    BKServiceCache.shared.setCachedActionItemRequiredFlag(items)
    expect(TabbrUtils.getTabbarViewController()).toNot(beNil())

    // WHEN
    BKContainer.routing.actionItem.routeToActionItem()

    // THEN: verify the navigation API call (no VC tree assertions)
    expectLastNav(
        toBe: String(describing: FRMWebviewNavigation.self),
        name: "FRMFraudReview",
        setAsRoot: true
    )
}


it("routes to FRMFraudReview (mobile-only) via FRMWebviewNavigation (setAsRoot)") {
    installNavigateSpyOnce()
    _lastCapturedNav = CapturedNav()

    // GIVEN: satisfy mobile-only gates
    BKAppState.didActionFraudAlertNotification = true
    writeOTVCPushTagForTests()
    swizzleOTCIfNeeded()

    let items = ActionItemRequiredFlagResponseDto(response: [
        "cdccRequired": false,
        "ccFraudReviewRequired": false,
        "fraudCaseReviewMobileOnlyRequired": true
    ])!
    BKServiceCache.shared.setCachedActionItemRequiredFlag(items)
    expect(TabbrUtils.getTabbarViewController()).toNot(beNil())

    // WHEN
    BKContainer.routing.actionItem.routeToActionItem()

    // THEN
    expectLastNav(
        toBe: String(describing: FRMWebviewNavigation.self),
        name: "FRMFraudReview",
        setAsRoot: true
    )
}
