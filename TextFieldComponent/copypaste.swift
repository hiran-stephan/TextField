var otvcService: OTVCServiceHandler = OTVCService()

func test_performPostSignOn_FraudCaseReviewMobileOnly_setsActionResponseTrue() {
    // Arrange
    let mockOTVC = MockOTVCService()
    mockOTVC.getRegisteredDeviceSuccess = true
    mockOTVC.mockRegisteredDeviceResponseDto = RegisteredDeviceResponseDto(
        response: ["nickname": "test",
                   "status": "DEVICE_PUSH_ENABLED"]
    )

    let service = SignInService()
    service.otvcService = mockOTVC   // now valid because we added the property

    // cache flags so first branch is taken
    let actionItemFlag = ActionItemRequiredFlagResponseDto(response: [
        "fraudCaseReviewRequired": false,
        "fraudCaseReviewMobileOnlyRequired": true
    ])
    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItemFlag)

    // ensure app state & feature flag allow this branch
    BKAppState.didActionFraudAlertNotification = true
    _ = FeatureHelper.hasFraudReviewEnabled() // or real setter

    // also make sure the keychain has a device tag (guard must pass)
    CIBCKeyChain.setPushOTVCRegisteredDeviceTag("dummy-tag")

    let expectation = self.expectation(description: "Completion")

    // Act
    service.performPostSignOnConcurrentFlow { (_, _, _, _, _, actionResponse) in
        // Assert
        XCTAssertTrue(actionResponse.value == true)
        expectation.fulfill()
    }

    waitForExpectations(timeout: 5)
}
