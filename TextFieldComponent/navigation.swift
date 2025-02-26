fun ConsentsViewModel.onValidateAndSubmit() {
    val hasPendingConsent = _consentUiState.value.data?.sections
        ?.flatMap { it.consentDocuments }
        ?.any { !it.isReviewed } ?: false

    val allConsentsProvided = _consentUiState.value.data?.sections
        ?.all { it.consentData.isConsentProvided } ?: false

    if (hasPendingConsent) {
        onConsentsErrorStateChanged()
    }

    if (!allConsentsProvided) {
        onConsentMethodErrorChanged()
    }

    if (!hasPendingConsent && allConsentsProvided) {
        updateConsentFunction()
    }
}
