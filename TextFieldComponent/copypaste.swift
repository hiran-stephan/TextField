import ObjectiveC.runtime
@testable import CIBC
@testable import BankKit   // where Router/NavigationOption live

// --- capture navigation (no storyboard side-effects) ---
private struct CapturedNav { var enumName="", navName=""; var isSetAsRoot=false }
private var _nav = CapturedNav()
private var _didSwizzleNavigate = false

extension UIViewController {
  // matches the production extension signature exactly
  @objc func _ut_navigate(enumName: String,
                          navigationName: String,
                          option: NavigationOption,
                          param: Any?,
                          moduleChanged: Bool) {
    _nav.enumName = enumName
    _nav.navName  = navigationName
    if case .setAsRoot = option { _nav.isSetAsRoot = true }
    // IMPORTANT: do NOT call the original (we don’t want real navigation in tests)
  }
}

private func installNavigateSpyOnce() {
  guard !_didSwizzleNavigate else { return }
  _didSwizzleNavigate = true
  let cls: AnyClass = UIViewController.self
  let origSel = NSSelectorFromString("navigateWithEnumName:navigationName:option:param:moduleChanged:")
  let replSel = #selector(UIViewController._ut_navigate(enumName:navigationName:option:param:moduleChanged:))
  guard let orig = class_getInstanceMethod(cls, origSel),
        let repl = class_getInstanceMethod(cls, replSel) else { return }
  method_exchangeImplementations(orig, repl)
}

// --- keychain helper: write a fake device tag the router will read ---
private func writeOTCPushTagForTests() {
  // Your Obj-C class exposes exactly this selector (see CIBCKeyChain.m)
  CIBCKeyChain.perform(NSSelectorFromString("setPushOTVCRegisteredDeviceTag:"),
                       with: "UNIT_TEST_DEVICE_TAG")
}

// --- service fake: always report “push enabled” for the tag ---
final class FakeOTCService: OTVCService {
  override func getRegisteredPushOTVCDevice(_ completion: @escaping OTVCServiceCompletionHandler,
                                            registeredDeviceTag: String) {
    let dto = RegisteredDeviceResponseDto()
    dto.status = .devicePushEnabled
    completion(dto, nil)
  }
}

private func installOTCMocks() {
  // prefer your project’s DI registration if available:
  BKContainer.services.register(serviceType: OTVCServiceProtocol.self) { _ in
    return FakeOTCService()
  }
  writeOTCPushTagForTests()
}


final class ActionItemWebViewRoutingImplementationSpec: QuickSpec {
  override func spec() {

    beforeSuite {
      installNavigateSpyOnce()
    }

    beforeEach {
      _nav = CapturedNav()
      TestAppDelegate().resetAppRouter()              // your existing helper
      BKContainer.routing.sideMenu.initNewSideMenuPostSignOn()
      let signon = SignOnResponseDto(response: [:])
      signon?.segment = .personalBanking
      BKServiceCache.shared.setCachedSignOnData(signon!)
      BKAppState.didActionFraudAlertNotification = true
    }

    it("routes to FRM Fraud Review (non-mobile-only)") {
      // GIVEN: FRM required (not mobile-only) and feature enabled
      let dto = ActionItemRequiredFlagResponseDto(response: [
        "cdcRequired": false,
        "ccFraudReviewRequired": true,
        "fraudCaseReviewMobileOnlyRequired": false
      ])!
      BKServiceCache.shared.setCachedActionItemRequiredFlag(dto)

      // AND: device registration gates satisfied
      installOTCMocks()

      // WHEN
      BKContainer.routing.actionItem.routeToActionItem()

      // THEN: correct navigation captured
      expect(_nav.enumName).toEventually(equal(String(describing: FRMWebViewNavigation.self)))
      expect(_nav.navName).toEventually(equal("FRMFraudReview"))
      expect(_nav.isSetAsRoot).toEventually(beTrue())
    }

    it("routes to FRM Fraud Review (mobile-only)") {
      // GIVEN: mobile-only flag and feature enabled
      let dto = ActionItemRequiredFlagResponseDto(response: [
        "cdcRequired": false,
        "ccFraudReviewRequired": false,
        "fraudCaseReviewMobileOnlyRequired": true
      ])!
      BKServiceCache.shared.setCachedActionItemRequiredFlag(dto)

      // AND: device registration gates satisfied
      installOTCMocks()

      // WHEN
      BKContainer.routing.actionItem.routeToActionItem()

      // THEN
      expect(_nav.enumName).toEventually(equal(String(describing: FRMWebViewNavigation.self)))
      expect(_nav.navName).toEventually(equal("FRMFraudReview"))
      expect(_nav.isSetAsRoot).toEventually(beTrue())
    }
  }
}
