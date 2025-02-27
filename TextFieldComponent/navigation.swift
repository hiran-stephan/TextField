package com.cibc.consents.ui.screens.consents

import kotlinx.coroutines.flow.update

class ConsentsViewModel {

    /** --- UI State Management --- **/
    
    fun onSubmitButtonClick() {
        val redirect = navigationItem.redirect
        if (redirect.isNotEmpty()) {
            router.redirectToDeepLink(redirect)
        } else {
            router.navigateToAuthenticated()
        }
    }

    fun onConsentDocumentReviewed(consentType: String) {
        consentUiState.update { previousState ->
            previousState.copy(
                data = previousState.data?.updateReviewStatus(consentType)
            )
        }
    }

    fun onConsentErrorStateChanged() {
        consentUiState.update { previousState ->
            previousState.copy(
                data = previousState.data?.updateConsentsError()
            )
        }
    }

    fun onConsentCheckboxChanged() {
        consentUiState.update { previousState ->
            previousState.copy(
                isCheckboxChecked = !previousState.isCheckboxChecked
            )
        }
    }

    fun onConsentErrorChanged() {
        consentUiState.update { previousState ->
            previousState.copy(
                isConsentError = !previousState.isConsentError
            )
        }
    }

    /** --- Utility Methods --- **/

    private fun hasPendingConsentDocumentReview(): Boolean =
        consentUiState.value.data?.groupedConsents?.values?.flatten()?.any { !it.isReviewed } ?: false

    fun validateAndSubmit() {
        val hasPendingConsentDocument = hasPendingConsentDocumentReview()

        if (hasPendingConsentDocument) {
            onConsentErrorStateChanged()
        }

        if (!consentUiState.value.isCheckboxChecked) {
            onConsentErrorChanged()
        }

        if (!hasPendingConsentDocument && consentUiState.value.isCheckboxChecked) {
            TODO(reason = "Call update consent function from here to update consents")
        }
    }
}
