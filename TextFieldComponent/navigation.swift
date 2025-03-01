fun ConsentsViewModel.onConsentDocumentReviewed(consentType: String) {
    consentUiState.update { previousState ->
        val consentData = previousState.findConsentByType(consentType) ?: return@update previousState
        previousState.addAcceptedConsent(consentData)
    }
}

// Helper function to find ConsentData by type
private fun ConsentsUiState.findConsentByType(consentType: String): ConsentData? {
    return this.data?.groupedConsents?.values
        ?.flatten()
        ?.find { it.consentType == consentType }
}

// Helper function to update acceptedConsents in state
// Helper function to update acceptedConsents **only if not already present**
private fun ConsentsUiState.addAcceptedConsent(consentData: ConsentData): ConsentsUiState {
    return if (this.acceptedConsents.any { it.consentType == consentData.consentType }) {
        this // Return unchanged state if consent is already accepted
    } else {
        this.copy(acceptedConsents = this.acceptedConsents + consentData)
    }
}
