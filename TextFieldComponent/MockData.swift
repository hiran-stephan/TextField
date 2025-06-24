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


SecondaryButton {
    Text(alertSettingsPresenter.alertCancelButtonText)
        .accessibilityLabel(alertSettingsPresenter.alertCancelButtonAccessibilityText)
} action: {
    viewModel.onCancelClicked()
}


try {
    val body = when (response.status) {
        HttpStatusCode.NoContent -> null
        else -> response.body<T>()
    }

    result(this, body) // Always call result

    globalCallbacks.onGlobalSuccess(
        referenceId = referenceId,
        response = response
    )

    body
}


.takeIf { it }?.let {
    repositoryAlertsCache.clear()
}
