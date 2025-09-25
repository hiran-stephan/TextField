fun ConsentsViewModel.createConsentSectionPresenter(
    sectionIndex: Int,
    documentList: List<ConsentData>,
): ConsentSectionPresenter =
    ConsentSectionPresenter(
        sectionIndex = sectionIndex,
        isCheckboxChecked = consentActionState.value.isCheckboxChecked,
        isConsentValidationFailed = consentActionState.value.isConsentValidationFailed,
        consentData = documentList,
        contentFile = consentResourceState.value.contentFile,
        locale = locale,
        messageCatalogue = messageCatalogue,
        // ⬇️ Only the types that belong to THIS section
        sectionTypes = documentList.map { it.consentType }.toSet()
    )


class ConsentSectionPresenter(
    private val contentFile: ContentFile?,
    private val locale: Locale,
    private val messageCatalogue: MessageCatalogue,
    private val consentData: List<ConsentData> = emptyList(),
    private val isCheckboxChecked: Boolean = false,
    private val isConsentValidationFailed: Boolean = false,
    private val sectionIndex: Int,
    private val sectionTypes: Set<String> = emptySet()
) {
    // ...
}


private fun singleAgreementKey(consentType: String) =
    "consents_${consentType}_agreement_title"

private fun combinedAgreementKey(types: Collection<String>): String {
    val joined = types.filter { it.isNotBlank() }.sorted().joinToString("_")
    return "consents_${joined}_agreement_title"
}

private fun displayContent(key: String, forAccessibility: Boolean = false): String =
    contentFile?.findContentValue(key, locale.lang, forAccessibility).orEmpty()

private fun getConsentText(consentType: String): String {
    val types = if (sectionTypes.isEmpty()) setOf(consentType) else sectionTypes

    // If multi-type section, try combined key first
    if (types.size > 1) {
        val key = combinedAgreementKey(types)
        val combined = displayContent(key)
        if (combined.isNotBlank() && combined != key) return combined

        // Fallback: join single titles (never show the key literal)
        return types.sorted()
            .map { displayContent(singleAgreementKey(it)) }
            .filter { it.isNotBlank() }
            .joinToString("\n")
    }

    // Single type section
    return displayContent(singleAgreementKey(consentType))
}


val isConsentRequired: Boolean = consentRequired(consentType, sectionTypes)
