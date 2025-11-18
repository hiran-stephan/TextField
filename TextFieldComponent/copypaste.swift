internal func evaluateMobileOnlyFraudAction(
    actionItemFlag: ActionItemRequiredFlagResponseDto,
    otvcService: OTVCServiceHandler,
    completion: @escaping (Results<Bool, ServiceException>) -> Void
) {
    var actionResponse: Results<Bool, ServiceException> = .failure(nil)

    guard actionItemFlag.fraudCaseReviewMobileOnlyRequired == true,
          BKAppState.didActionFraudAlertNotification == true,
          FeatureHelper.hasFraudReviewEnabled() else {
        completion(actionResponse)
        return
    }

    guard let deviceTag = CIBCKeyChain.getPushOTVCRegisteredDeviceTag() else {
        completion(actionResponse)
        return
    }

    otvcService.getRegisteredPushOTVCDevice(registerdDeviceTag: deviceTag) { responseObj, _ in
        if let response = responseObj as? RegisteredDeviceResponseDto,
           response.status == .devicePushEnabled {
            actionResponse = .success(true)
        }
        completion(actionResponse)
    }
}


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
    CIBCKeyChain.setPushOTVCRegisteredDeviceTag("dummy-tag")

    let expectation = expectation(description: "Completion")

    service.evaluateMobileOnlyFraudAction(
        actionItemFlag: actionItemFlag,
        otvcService: mockOTVC
    ) { result in
        XCTAssertTrue(result.value == true)
        expectation.fulfill()
    }

    waitForExpectations(timeout: 2)
}


func test_evaluateMobileOnlyFraudAction_failure_conditionsNotMet() {
    let mockOTVC = MockOTVCService()
    mockOTVC.getRegisteredDeviceSuccess = false

    let service = SignInService()
    let actionItemFlag = ActionItemRequiredFlagResponseDto(response: [
        "fraudCaseReviewMobileOnlyRequired": false
    ])!

    BKAppState.didActionFraudAlertNotification = false

    let expectation = expectation(description: "Completion")

    service.evaluateMobileOnlyFraudAction(
        actionItemFlag: actionItemFlag,
        otvcService: mockOTVC
    ) { result in
        XCTAssertFalse(result.value == true)
        expectation.fulfill()
    }

    waitForExpectations(timeout: 2)
}
