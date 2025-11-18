// 1) helper for normal fraud / KYC flags
internal func evaluateActionResponse(
    actionItemFlag: ActionItemRequiredFlagResponseDto
) -> Results<Bool, ServiceException> {

    if actionItemFlag.fraudCaseReviewRequired == true &&
        FeatureHelper.hasFraudReviewEnabled() {
        return .success(true)
    }

    if actionItemFlag.ccFraudReviewRequired == true &&
        FeatureHelper.hasFraudOptimizationEnabled() {
        return .success(true)
    }

    if actionItemFlag.investmentKycReviewDue == true &&
        FeatureHelper.hasKYCKEnabled() &&
        ActionItemsHelper.isSegmentEligibleForKyc() {
        return .success(true)
    }

    return .failure(nil)
}

// 2) mobile-only helper (you already have this)
internal func evaluateMobileOnlyFraudAction(
    actionItemFlag: ActionItemRequiredFlagResponseDto,
    otvcService: OTVServiceHandler,
    completion: @escaping (Results<Bool, ServiceException>) -> Void
) {
    var actionResponse: Results<Bool, ServiceException> = .failure(nil)

    guard actionItemFlag.fraudCaseReviewMobileOnlyRequired == true,
          BKAppState.didActionFraudAlertNotification == true,
          FeatureHelper.hasFraudReviewEnabled(),
          let deviceTag = CIBCKeyChain.getPushOTVCRegisteredDeviceTag()
    else {
        completion(actionResponse)
        return
    }

    otvcService.getRegisteredPushOTVCDevice({ responseObj in
        if let response = responseObj as? RegisteredDeviceResponseDto,
           response.status == .devicePushEnabled {
            actionResponse = .success(true)
        }
        completion(actionResponse)
    }, registeredDeviceTag: deviceTag)
}


if let actionItemFlag = BKServiceCache.shared.getCachedActionItemRequiredFlag() {

            dispatchGroup.enter()
            self.evaluateMobileOnlyFraudAction(
                actionItemFlag: actionItemFlag,
                otvcService: self.otvcService
            ) { mobileOnlyResult in
                if mobileOnlyResult.value == true {
                    actionResponse = mobileOnlyResult
                } else {
                    // fall back to normal fraud / KYC evaluation
                    actionResponse = self.evaluateActionResponse(
                        actionItemFlag: actionItemFlag
                    )
                }
                dispatchGroup.leave()
            }
        }
