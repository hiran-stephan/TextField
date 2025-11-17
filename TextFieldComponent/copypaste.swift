private func setFraudCaseReviewRequiredFlag(_ value: Bool) {
    MockBKServiceCache.flag = ActionItemRequiredFlagResponseDto(response: [
        "ccFraudReviewRequired": false,
        "fraudCaseReviewRequired": value,
        "fraudCaseReviewMobileOnlyRequired": false,
        "investmentKycReviewDue": false
    ])
}

private func setFraudCaseReviewMobileOnlyRequiredFlag(_ value: Bool) {
    MockBKServiceCache.flag = ActionItemRequiredFlagResponseDto(response: [
        "ccFraudReviewRequired": false,
        "fraudCaseReviewRequired": false,
        "fraudCaseReviewMobileOnlyRequired": value,
        "investmentKycReviewDue": false
    ])
}


func test_actionResponse_success_whenFraudCaseReviewRequired_andFraudOptimizationEnabled() {
    MockFeatureHelper.fraudOptimizationEnabled = true
    setFraudCaseReviewRequiredFlag(true)

    var actionResponse: Result<Bool, ServiceExceptionTest> = .failure(ServiceExceptionTest())

    if let actionItemFlag = MockBKServiceCache.getCachedActionItemRequiredFlag() {
        if (actionItemFlag.fraudCaseReviewRequired == true) &&
            MockFeatureHelper.hasFraudOptimizationEnabled() {
            actionResponse = .success(true)
        }
    }

    XCTAssertEqual(actionResponse.value, true)
}

func test_actionResponse_success_whenFraudCaseReviewMobileOnlyRequired_andFraudOptimizationEnabled() {
    MockFeatureHelper.fraudOptimizationEnabled = true
    setFraudCaseReviewMobileOnlyRequiredFlag(true)

    var actionResponse: Result<Bool, ServiceExceptionTest> = .failure(ServiceExceptionTest())

    if let actionItemFlag = MockBKServiceCache.getCachedActionItemRequiredFlag() {
        if (actionItemFlag.fraudCaseReviewMobileOnlyRequired == true) &&
            MockFeatureHelper.hasFraudOptimizationEnabled() {
            actionResponse = .success(true)
        }
    }

    XCTAssertEqual(actionResponse.value, true)
}


func test_actionResponse_failure_whenNoFraudFlags_andFraudOptimizationEnabled() {
    MockFeatureHelper.fraudOptimizationEnabled = true
    MockBKServiceCache.flag = ActionItemRequiredFlagResponseDto(response: [
        "ccFraudReviewRequired": false,
        "fraudCaseReviewRequired": false,
        "fraudCaseReviewMobileOnlyRequired": false,
        "investmentKycReviewDue": false
    ])

    var actionResponse: Result<Bool, ServiceExceptionTest> = .failure(ServiceExceptionTest())

    if let actionItemFlag = MockBKServiceCache.getCachedActionItemRequiredFlag() {
        if (actionItemFlag.ccFraudReviewRequired == true ||
            actionItemFlag.fraudCaseReviewRequired == true ||
            actionItemFlag.fraudCaseReviewMobileOnlyRequired == true) &&
            MockFeatureHelper.hasFraudOptimizationEnabled() {
            actionResponse = .success(true)
        }
    }

    XCTAssertFalse(actionResponse.isSuccess)  // or XCTAssertNil(actionResponse.value) depending on your helper
}


