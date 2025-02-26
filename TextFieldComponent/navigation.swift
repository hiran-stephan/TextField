private fun getConsents() {
    launch(_consentUiState) {
        val consentDocuments = sessionDataProvider.getConsents()

        // Group consents by consentType
        val consentSections = consentDocuments
            .groupBy { it.consentType }
            .map { (type, documents) ->
                ConsentSection(
                    title = "Consent Type: $type",
                    consentData = ConsentData(
                        consentText = "Review required for type $type",
                        isConsentProvided = false,  // Always false initially
                        consentError = null  // Always null initially
                    ),
                    consentDocuments = documents
                )
            }

        // Update UI state with new data
        _consentUiState.value = _consentUiState.value.copy(
            data = ConsentsData(sections = consentSections)
        )
    }
}
