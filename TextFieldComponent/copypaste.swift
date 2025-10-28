private func confirmRegisteredDeviceThenRouteFRM(mobileOnly: Bool,
                                                 userInfo: [AnyHashable: Any]) {
    // If it isn’t a mobile-only case, route immediately.
    guard mobileOnly else {
        self.routeToFRM(with: userInfo)
        return
    }

    // 1) get device tag from Keychain (Obj-C method you showed)
    guard let deviceTag = CIBCKeyChain.getPushOTVCRegisteredDeviceTag(),
          deviceTag.isEmpty == false
    else {
        presentNotRegisteredModal() // or fallback
        return
    }

    // 2) call the API with x-device-tag
    DeviceRegistrationService.shared.isPushRegisteredDevice(deviceTag: deviceTag) { result in
        DispatchQueue.main.async {
            switch result {
            case .success(let isRegistered):
                if isRegistered {
                    // 3) proceed to FRM
                    self.routeToFRM(with: userInfo)
                } else {
                    // 4) show message / fallback
                    self.presentNotRegisteredModal()
                }
            case .failure:
                // conservative: treat as not registered (or show a retry)
                self.presentNotRegisteredModal()
            }
        }
    }
}


// When post sign-on and came from user tap:
if ApplicationSettings.isApplicationLoggedIn() {
    presentFRMInterruptionModal { // CTA “Review now”
        // Determine if this is the *mobile-only* variant.
        let mobileOnly = PushNotificationUtil.isFraudCaseReviewMobileOnlyRequired(userInfo)
        self.confirmRegisteredDeviceThenRouteFRM(mobileOnly: mobileOnly, userInfo: userInfo)
    }
    return
}
