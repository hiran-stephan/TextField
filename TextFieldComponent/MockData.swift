./gradlew --refresh-dependencies


nano ~/.gradle/gradle.properties

private var alertSuccessMessageId: String? {
    model.state?.showAlertPreferenceUpdateSuccessMessage?.id
}

.onReceive(Just(alertSuccessMessageId).removeDuplicates()) { id in
    guard let _ = id else { return }
    showAlertPreferenceUpdateSuccessMessage = model.state?.showAlertPreferenceUpdateSuccessMessage
}

.onReceive(model.statePublisher.map { $0.showAlertPreferenceUpdateSuccessMessage?.id }.removeDuplicates()) { _ in
    self.showAlertPreferenceUpdateSuccessMessage = model.state?.showAlertPreferenceUpdateSuccessMessage
}


.sortedBy { it.showAddMobileNumberLink } // false (default) comes first, true goes last
