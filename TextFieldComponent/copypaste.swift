group.enter() // API #1
actionItemService.getCdcPromptRequiredAndSkipValue { response in
    defer { group.leave() } // guarantees leave for API #1

    let needsSecondCall =
        BKServiceCache.shared.getCachedActionItemRequiredFlag()?.fraudCaseReviewMobileOnlyRequired == true &&
        BKAppState.didActionFraudAlertNotification == true &&
        FeatureHelper.hasFraudReviewEnabled()

    guard needsSecondCall, let deviceTag = CITKeyChain.getPushOTVCRegisteredDeviceTag() else {
        actionResponse = .success(true)
        return
    }

    group.enter() // API #2
    otvcService.getRegisteredPushOTVCDevice(registeredDeviceTag: deviceTag) { responseObj, _, _ in
        defer { group.leave() } // guarantees leave for API #2
        if let dto = responseObj as? RegisteredDeviceResponseDto,
           dto.status == .devicePushEnabled {
            actionResponse = .success(true)
        } else {
            // decide what you want on "not enabled" (keep as-is or set failure)
        }
    }
}
