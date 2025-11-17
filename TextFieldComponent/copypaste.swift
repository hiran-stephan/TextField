func test_performPostSignOn_FraudCaseReviewRequired_setsActionResponseTrue() {
    let mockOTVC = MockOTVCService()
    mockOTVC.getRegisteredDeviceSuccess = true
    mockOTVC.getRegisteredDeviceResponseDto = RegisteredDeviceResponseDto(status: .devicePushEnabled)

    let service = SignInService()
    service.otvcService = mockOTVC

    let actionItemFlag = ActionItemRequiredFlagResponseDto(response: [
        "fraudCaseReviewRequired": true,
        "fraudCaseReviewMobileOnlyRequired": false
    ])

    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItemFlag)
    FeatureHelper.setFraudReviewEnabled(true)

    let expectation = self.expectation(description: "Completion")

    service.performPostSignOnConcurrentFlow { (_,_,_,_,_,actionResponse) in
        XCTAssertTrue(actionResponse.value == true)
        expectation.fulfill()
    }

    waitForExpectations(timeout: 5)
}



func test_performPostSignOn_FraudCaseReviewMobileOnly_setsActionResponseTrue() {
    let mockOTVC = MockOTVCService()
    mockOTVC.getRegisteredDeviceSuccess = true
    mockOTVC.getRegisteredDeviceResponseDto = RegisteredDeviceResponseDto(status: .devicePushEnabled)

    let service = SignInService()
    service.otvcService = mockOTVC

    let actionItemFlag = ActionItemRequiredFlagResponseDto(response: [
        "fraudCaseReviewRequired": false,
        "fraudCaseReviewMobileOnlyRequired": true
    ])

    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItemFlag)
    FeatureHelper.setFraudReviewEnabled(true)

    let expectation = self.expectation(description: "Completion")

    service.performPostSignOnConcurrentFlow { (_,_,_,_,_,actionResponse) in
        XCTAssertTrue(actionResponse.value == true)
        expectation.fulfill()
    }

    waitForExpectations(timeout: 5)
}

