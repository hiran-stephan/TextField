// Combined title only when THIS section has multiple types.
// Otherwise show the single title for the section's (or row's) consent type.
private fun getConsentText(consentType: String): String {
    val typesInThisSection = if (sectionTypes.isEmpty()) setOf(consentType) else sectionTypes

    // If this section has more than one type, try the combined key for this section only
    if (typesInThisSection.size > 1) {
        val combinedKey = combinedAgreementKey(typesInThisSection)
        val combined = resolveKeyOrEmpty(combinedKey)
        if (combined.isNotBlank()) return combined
        // Fallback: join individual titles (never show the raw key)
        return typesInThisSection.sorted()
            .map { displayContent(singleAgreementKey(it)) }
            .filter { it.isNotBlank() }
            .joinToString(separator = "\n")
    }

    // Single-type section → single key
    return displayContent(singleAgreementKey(consentType))
}
