private fun getConsents() {
    launch(consentUiState) {
        val consents = consentsProvider.getConsents()
        val groupedConsents = consents
            .map { it.updateIfAccepted(consentUiState.value.acceptedConsents) } // Update only `isReviewed` and `error`
            .groupBy { it.consentType }

        consentUiState.update { previousState ->
            previousState.copy(
                data = ConsentsData(groupedConsents)
            )
        }
    }
}

// Helper function to update only `isReviewed` and `error`
private fun ConsentData.updateIfAccepted(acceptedConsents: List<ConsentData>): ConsentData {
    val acceptedConsent = acceptedConsents.find { it.consentType == this.consentType }
    return if (acceptedConsent != null) {
        this.copy(
            isReviewed = acceptedConsent.isReviewed, // Only update isReviewed
            error = acceptedConsent.error // Only update error
        )
    } else {
        this // Return original if not in acceptedConsents
    }
}
