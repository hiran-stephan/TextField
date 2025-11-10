struct PostSignOnContext {
    var promptRequired: Bool = false
    var devicePushEnabled: Bool?
    var registeredDeviceTag: String?
}

private func fetchCDCPromptRequirement(
    completion: @escaping (CDCActionItemsDataModel?) -> Void
) {
    let apiHelper = ActionItemServiceAPICallHelper()
    apiHelper.getCDCPromptRequiredAndSkipValue { response, exception in
        guard exception == nil, let response = response else {
            completion(nil)
            return
        }
        completion(response)
    }
}

private func shouldPerformRegisteredDeviceCheck(
    promptRequired: Bool
) -> Bool {
    let fraudPushReceived = (
        BKServiceCache.shared
            .getCachedActionItemRequiredFlag()?.fraudCaseReviewMobileOnlyRequired == true
    ) || FeatureHelper.hasFraudReviewEnabled()

    let deviceTag = CIBCKeyChain.getPushOTVCRegisteredDeviceTag()
    
    // Only call if fraud push received, user not logged in, and no tag present
    if fraudPushReceived, deviceTag == nil {
        return true
    }

    // If prompt is already required, no need to call second API
    return false
}


private func fetchRegisteredDeviceInfo(
    completion: @escaping (RegisteredDeviceResponseDto?) -> Void
) {
    let otvcService = OTVCService()
    otvcService.getRegisteredPushOTVCDevice { responseObj, _ in
        let dto = responseObj as? RegisteredDeviceResponseDto
        completion(dto)
    } registeredDeviceTag: (CIBCKeyChain.getPushOTVCRegisteredDeviceTag() ?? "")
}


private func performPostSignOnConcurrentFlow(
    result: @escaping PostSignOnDataClosure
) {
    let dispatchGroup = DispatchGroup()
    var context = PostSignOnContext()
    
    // Step 1: Fetch CDC Prompt Requirement
    dispatchGroup.enter()
    fetchCDCPromptRequirement { dataModel in
        context.promptRequired = dataModel?.promptRequired ?? false
        dispatchGroup.leave()
    }

    // Step 2: Fetch Financial Advisor (unchanged)
    dispatchGroup.enter()
    BKContactUsWorker().getFinancialAdvisorData { _ in
        dispatchGroup.leave()
    }

    // Step 3: Once both finish, decide if device check needed
    dispatchGroup.notify(queue: .main) { [weak self] in
        guard let self = self else { return }

        if self.shouldPerformRegisteredDeviceCheck(promptRequired: context.promptRequired) {
            self.fetchRegisteredDeviceInfo { dto in
                if dto?.status == .devicePushEnabled {
                    context.devicePushEnabled = true
                    context.registeredDeviceTag = dto?.nickname
                }
                result(.success(true))
            }
        } else {
            // No device check needed
            result(.success(true))
        }
    }
}


// ... inside performPostSignOnConcurrentFlow

// after scheduling API #1 + (optional) API #2 and any other enters/leaves:
dispatchGroup.notify(queue: .main) { [weak self] in
    guard let self = self else { return }

    // mirror your two cache/feature checks – these just *set* actionResponse
    if BKServiceCache.shared.getCachedActionItemRequiredFlag()?.ccFraudReviewRequired == true
        && FeatureHelper.hasFraudOptimizationEnabled() {
        actionResponse = .success(true)
    }

    if BKServiceCache.shared.getCachedActionItemRequiredFlag()?.fraudCaseReviewRequired == true
        && FeatureHelper.hasFraudReviewEnabled() {
        actionResponse = .success(true)
    }

    // any final UI prep you already do
    self.setupMediaII()

    // single completion call
    result(profileResponse,
           targetedOfferAccountResponse,
           accountResponse,
           mtoResponse,
           docResponse,
           actionResponse)
}

