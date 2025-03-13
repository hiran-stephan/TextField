private fun ConsentsViewModel.hasPendingConsent(): Boolean {
    return consentUiState.value.findConsentByType(EDCA_TYPE)
        ?.let { !consentUiState.value.isCheckboxChecked } ?: false
}



fun ConsentsViewModel.onValidateAndSubmit() {
    analyticsHelper.trackReviewAgreementsSubmitAction()

    val hasPendingConsent = hasPendingConsent()
    val hasPendingReview = hasPendingConsentDocumentReview()

    if (hasPendingConsent || hasPendingReview) {
        onConsentValidationFailed()
    } else {
        updateConsents()
    }
}
