fun ConsentsUiState.getConsentPathByType(consentType: String): String? {
    return this.data?.groupedConsents?.values
        ?.flatten() // Convert Map<String, List<ConsentData>> to List<ConsentData>
        ?.find { it.consentType == consentType } // Find the matching consentType
        ?.consentPath
}
