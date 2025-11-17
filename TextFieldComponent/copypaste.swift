func test_performPostSignOnConcurrentFlow_FraudCaseReviewMobileOnly_SetsActionResponseTrue() {
    let service = SignInService()
    let actionItemFlag = ActionItemRequiredFlagResponseDto(response: [
        "fraudCaseReviewMobileOnlyRequired": true,
        "fraudCaseReviewRequired": false
    ])
    BKServiceCache.shared.setCachedActionItemRequiredFlag(actionItemFlag)
    BKAppPipeline.lineOfBusiness = .cibc
    FeatureHelper.hasFraudReviewEnabled = true

    // mock keychain & OTVC service to:
    //  - return a deviceTag
    //  - return status = .pushEnabled

    let expectation = self.expectation(description: "Completion")
    service.performPostSignOnConcurrentFlow { (_, _, _, _, actionResponse) in
        XCTAssertTrue(actionResponse.value == true)
        expectation.fulfill()
    }
    waitForExpectations(timeout: 5)
}
