// keep it internal so tests can see it
internal func evaluateFraudAction(
    actionItemFlag: ActionItemRequiredFlagResponseDto?,
    otvcService: OTVCServiceHandler,
    keychain: PushOTVCKeychainProtocol,
    appState: BKAppStateProtocol,
    featureHelper: FeatureHelperProtocol,
    completion: @escaping (Results<Bool, ServiceException>) -> Void
) {
    var actionResponse: Results<Bool, ServiceException> = .failure(nil)

    if actionItemFlag?.fraudCaseReviewMobileOnlyRequired == true &&
       appState.didActionFraudAlertNotification == true &&
       featureHelper.hasFraudReviewEnabled() {

        guard let deviceTag = keychain.getPushOTVCRegisteredDeviceTag() else {
            completion(actionResponse)
            return
        }

        otvcService.getRegisteredPushOTVCDevice(deviceTag) { (responseObj, _) in
            if let response = responseObj as? RegisteredDeviceResponseDto,
               response.status == .devicePushEnabled {
                actionResponse = .success(true)
            }
            completion(actionResponse)
        }

    } else if actionItemFlag?.fraudCaseReviewRequired == true &&
              featureHelper.hasFraudReviewEnabled() {
        actionResponse = .success(true)
        completion(actionResponse)

    } else {
        completion(actionResponse)
    }
}


func test_evaluateFraudAction_FraudCaseReviewMobileOnly_setsSuccessTrue() {
    // Arrange
    let actionItemFlag = ActionItemRequiredFlagResponseDto(response: [
        "fraudCaseReviewRequired": false,
        "fraudCaseReviewMobileOnlyRequired": true
    ])!

    class MockOTVC: OTVCServiceHandler {
        func getRegisteredPushOTVCDevice(
            _ registeredDeviceTag: String,
            _ onCompletion: @escaping OTVCServiceCompletionHandler
        ) {
            let dto = RegisteredDeviceResponseDto(response: [
                "status": "DEVICE_PUSH_ENABLED",
                "nickname": "test"
            ])!
            onCompletion(dto, nil)
        }
    }

    class MockKeychain: PushOTVCKeychainProtocol {
        func getPushOTVCRegisteredDeviceTag() -> String? { "dummy-tag" }
    }

    class MockAppState: BKAppStateProtocol {
        var didActionFraudAlertNotification = true
    }

    class MockFeatureHelper: FeatureHelperProtocol {
        func hasFraudReviewEnabled() -> Bool { true }
    }

    let service = SignInService()
    let mockOTVC = MockOTVC()
    let mockKeychain = MockKeychain()
    let mockAppState = MockAppState()
    let mockFeature = MockFeatureHelper()

    let expectation = self.expectation(description: "fraud mobile only")

    // Act
    service.evaluateFraudAction(
        actionItemFlag: actionItemFlag,
        otvcService: mockOTVC,
        keychain: mockKeychain,
        appState: mockAppState,
        featureHelper: mockFeature
    ) { result in
        // Assert
        XCTAssertTrue(result.value == true)
        expectation.fulfill()
    }

    waitForExpectations(timeout: 1)
}



