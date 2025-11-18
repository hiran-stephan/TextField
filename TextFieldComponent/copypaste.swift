func test_evaluateMobileOnlyFraudAction_success() {
    let mockOTVC = MockOTVCService()
    mockOTVC.getRegisteredDeviceSuccess = true
    mockOTVC.mockRegisteredDeviceResponseDto =
        RegisteredDeviceResponseDto(response: ["status": "DEVICE_PUSH_ENABLED"])

    let service = SignInService()
    let actionItemFlag = ActionItemRequiredFlagResponseDto(response: [
        "fraudCaseReviewMobileOnlyRequired": true
    ])!

    BKAppState.didActionFraudAlertNotification = true
    FeatureHelper.setFraudReviewEnabled(true)
    CIBCKeyChain.setPushOTVCRegisteredDeviceTag("dummy-tag")

    let expectation = self.expectation(description: "Completion")

    service.evaluateMobileOnlyFraudAction(
        actionItemFlag: actionItemFlag,
        otvcService: mockOTVC
    ) { result in
        XCTAssertTrue(result.value == true)
        expectation.fulfill()
    }

    waitForExpectations(timeout: 3)
}


func test_evaluateMobileOnlyFraudAction_conditionsNotMet_returnsFailure() {
    let mockOTVC = MockOTVCService()
    let service = SignInService()

    let actionItemFlag = ActionItemRequiredFlagResponseDto(response: [
        "fraudCaseReviewMobileOnlyRequired": false
    ])!

    let expectation = self.expectation(description: "Completion")

    service.evaluateMobileOnlyFraudAction(
        actionItemFlag: actionItemFlag,
        otvcService: mockOTVC
    ) { result in
        XCTAssertFalse(result.value == true)
        expectation.fulfill()
    }

    waitForExpectations(timeout: 3)
}
