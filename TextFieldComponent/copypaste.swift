private fun singleAgreementKey(consentType: String): String =
    "consents_${consentType}_agreement_title"

private fun combinedAgreementKey(consentTypes: Collection<String>): String {
    val joined = consentTypes.filter { it.isNotBlank() }.sorted().joinToString("_")
    return "consents_${joined}_agreement_title"
}

private fun getConsentText(consentType: String): String {
    // 1) If there are multiple types on the page, try a combined key
    if (allTypesOnPage.isNotEmpty()) {
        val combinedKey = combinedAgreementKey(allTypesOnPage)
        val combined = displayContent(combinedKey)
        if (combined.isNotBlank()) return combined
    }

    // 2) Fallback to the single-type key for this section
    return displayContent(singleAgreementKey(consentType))
}

