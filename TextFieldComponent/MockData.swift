./gradlew --refresh-dependencies


nano ~/.gradle/gradle.properties

private var alertSuccessMessageId: String? {
    model.state?.showAlertPreferenceUpdateSuccessMessage?.id
}

.onReceive(Just(alertSuccessMessageId).removeDuplicates()) { id in
    guard let _ = id else { return }
    showAlertPreferenceUpdateSuccessMessage = model.state?.showAlertPreferenceUpdateSuccessMessage
}


