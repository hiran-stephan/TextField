public var webViewUrlDigitalFRM: String?
public var webViewUrlDigitalFRMFraudReview: String?

func testRetrieveAppConfigData() {
    // ... existing arrange code ...

    let retrievedAppConfigData = AppConfigResponseDto(response: mockAppConfigData1)

    XCTAssertEqual(retrievedAppConfigData.webViewUrlDigitalFRM,
                   webViewUrlDigitalFRM)
    XCTAssertEqual(retrievedAppConfigData.webViewUrlDigitalFRMFraudReview,
                   webViewUrlDigitalFRMFraudReview)
}

func test_FRMWebViewNavigation_valueForDescription_FraudReview() {
    let nav = FRMWebViewNavigation.valueFor(description: "FRMFraudReview",
                                            option: nil)

    guard case .FRMFraudReview = nav! else {
        XCTFail("Expected FRMFraudReview navigation")
        return
    }
}

class FRMWebViewRoutingServiceMock: FRMWebViewRoutingService {
    var didRouteToMain = false
    var didRouteToFraudReview = false

    func routeToFRMWebView() { didRouteToMain = true }
    func routeToFRMFraudReviewWebView() { didRouteToFraudReview = true }
}


var mockAppConfigData2: AppConfigResponseDto?

func initialize() {
    cache = BKServiceCache.shared
    var mockAppConfigData2 = AppConfigResponseDto(response: [String: Any]())
    mockAppConfigData2.webViewUrlDigitalFRM =
        "/ebm-resources/public/fraud-notifications/client/index.html#/protect-account" + FRMConstants.urlParams
    cache?.setCachedAppConfig(mockAppConfigData2)

    subject = storyboard.instantiateViewController(withIdentifier: "FRMWebViewController") as? FRMWebViewController
}

mockAppConfigData2.webViewUrlDigitalFRMFraudReview =
    "/ebm-resources/public/fraud-notifications/client/index.html#/push-alerts/transition" + FRMConstants.urlParams


context("When user is redirected to FRM Fraud Review flow") {
    beforeEach {
        initialize()
        subject.state = .FRMFraudReview  // <- new state
        subject.loadViewIfNeeded()
        subject.beginAppearanceTransition(true, animated: true)
        subject.endAppearanceTransition()
    }

    it("should have FRM Fraud Review URL loaded on WebView") {
        guard enableFlakyTests else { return }

        let expectedPath = "/fraud-notifications/client/index.html#/push-alerts/transition"
        expect(subject.webView.currentURL()?.absoluteString.contains(expectedPath))
            .toEventually(beTrue(), timeout: .seconds(5))
    }
}



