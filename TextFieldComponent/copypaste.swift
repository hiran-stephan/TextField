private fun consentRequired(consentType: String): Boolean {
    // What docs are in this section?
    val types = consentData.map { it.consentType }.toSet()

    return when {
        // EDCA present → checkbox required (existing rule)
        types.contains(EDCA_TYPE) -> true

        // DBSA-only section (no EDCA, no EDAD) → checkbox required
        types.size == 1 && types.contains(DBSA_TYPE) -> true

        else -> false
    }
}

private fun ConsentsViewModel.isCheckboxRequiredForFlow(): Boolean {
    val groups = consentUiState.value.data?.groupedConsents?.values ?: return false
    val types = groups.flatten().map { it.consentType }

    val hasEdca = types.contains(EDCA_TYPE)
    val dbsaOnly = types.size == 1 && types.firstOrNull() == DBSA_TYPE

    return hasEdca || dbsaOnly
}

fun ConsentsViewModel.getConsentValidationErrorCount(): Int {
    if (!consentActionState.value.isConsentValidationFailed) return 0

    var errorCount = 0

    // documents not reviewed
    val unreviewedCount = consentUiState.value.data
        ?.groupedConsents?.values
        ?.flatten()
        ?.count { !it.isReviewed } ?: 0
    errorCount += unreviewedCount

    // checkbox (EDCA or DBSA-only)
    val isRequired = isCheckboxRequiredForFlow()
    val isChecked = consentActionState.value.isCheckboxChecked
    if (isRequired && !isChecked) errorCount += 1

    return errorCount
}

