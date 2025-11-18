func test_actionResponse_success_whenFraudReviewRequired_andFraudOptimizationEnabled() {
    // Arrange
    let service = SignInService()
    
    let actionItemFlag = ActionItemRequiredFlagResponseDto(response: [
        "ccFraudReviewRequired": false,
        "investmentKycReviewDue": false,
        "fraudCaseReviewRequired": true,
        "fraudCaseReviewMobileOnlyRequired": false
    ])
    
    // feature flag ON for fraud review
    // (use whatever helper you already have in tests to flip this)
    FeatureHelper.setFraudReviewEnabledForUnitTest(true)
    FeatureHelper.setFraudOptimizationEnabledForUnitTest(true)
    FeatureHelper.setKYCKEnabledForUnitTest(false)
    
    // Act
    let result = service.evaluateActionResponse(actionItemFlag: actionItemFlag)
    
    // Assert
    XCTAssertEqual(result.value, true)
}


func test_actionResponse_success_whenKycReviewDue_KYCEnabled_segmentEligible_setActionResponseTrue() {
    // Arrange
    let service = SignInService()
    
    let actionItemFlag = ActionItemRequiredFlagResponseDto(response: [
        "ccFraudReviewRequired": false,
        "investmentKycReviewDue": true,
        "fraudCaseReviewRequired": false,
        "fraudCaseReviewMobileOnlyRequired": false
    ])
    
    // feature flags for KYC path
    FeatureHelper.setFraudReviewEnabledForUnitTest(false)
    FeatureHelper.setFraudOptimizationEnabledForUnitTest(false)
    FeatureHelper.setKYCKEnabledForUnitTest(true)
    ActionItemsHelper.setSegmentEligibleForKycForUnitTest(true)
    
    // Act
    let result = service.evaluateActionResponse(actionItemFlag: actionItemFlag)
    
    // Assert
    XCTAssertEqual(result.value, true)
}


func test_actionResponse_failure_whenNoFraudFlags_andFraudOptimizationDisabled() {
    // Arrange
    let service = SignInService()
    
    let actionItemFlag = ActionItemRequiredFlagResponseDto(response: [
        "ccFraudReviewRequired": false,
        "investmentKycReviewDue": false,
        "fraudCaseReviewRequired": false,
        "fraudCaseReviewMobileOnlyRequired": false
    ])
    
    // turn everything OFF
    FeatureHelper.setFraudReviewEnabledForUnitTest(false)
    FeatureHelper.setFraudOptimizationEnabledForUnitTest(false)
    FeatureHelper.setKYCKEnabledForUnitTest(false)
    ActionItemsHelper.setSegmentEligibleForKycForUnitTest(false)
    
    // Act
    let result = service.evaluateActionResponse(actionItemFlag: actionItemFlag)
    
    // Assert
    XCTAssertEqual(result.value, false)
}


