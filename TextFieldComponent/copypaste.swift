fun createConsentSectionPresenter(
    documentList: List<ConsentData>,
    consentCount: Int,
): ConsentSectionPresenter =
    ConsentSectionPresenter(
        isCheckboxChecked = consentActionState.value.isCheckboxChecked,
        isConsentValidationFailed = consentActionState.value.isConsentValidationFailed,
        consentData = documentList,
        contentFile = consentResourceState.value.contentFile,
        locale = locale,
        messageCatalogue = messageCatalogue,
        consentCount = consentCount,
        allTypesOnPage = consentsUiState.value.data   // NEW
            ?.groupedConsents
            ?.values
            ?.flatten()
            ?.map { it.consentType }
            ?.toSet()
            ?: emptySet()
    )


class ConsentSectionPresenter(
    private val contentFile: ContentFile?,
    private val locale: Locale,
    private val messageCatalogue: MessageCatalogue,
    private val consentData: List<ConsentData> = emptyList(),
    private val isCheckboxChecked: Boolean = false,
    private val isConsentValidationFailed: Boolean = false,
    private val consentCount: Int,
    private val allTypesOnPage: Set<String> = emptySet()   // NEW
) {
    ...
}


private fun consentRequired(consentType: String): Boolean {
    // Section types (kept in case you need secondary checks)
    val sectionTypes = consentData.map { it.consentType }.toSet()

    return when {
        // EDCA section → always checkbox
        consentType == EDCA_TYPE -> true

        // DBSA section → checkbox only when EDCA is NOT anywhere on the page
        consentType == DBSA_TYPE -> !allTypesOnPage.contains(EDCA_TYPE)

        // Everything else → no checkbox (DBSA+EDAD or EDAD-only)
        else -> false
    }
}


private fun getConsentText(consentType: String): String {
    return when (consentType) {
        // EDCA (13) → always its own text
        EDCA_TYPE -> displayContent(CONSENTS_EDCA_AGREEMENT_TITLE)

        // DBSA (14)
        DBSA_TYPE -> when {
            // EDCA + DBSA → 13+14 combined text
            allTypesOnPage.contains(EDCA_TYPE) ->
                displayContent(CONSENTS_DBSA_EDCA_AGREEMENT_TITLE) // key: "consents_13_14_agreement_title"

            // DBSA + EDAD (no EDCA) → 14+19 combined text
            allTypesOnPage.contains(EDAD_TYPE) && !allTypesOnPage.contains(EDCA_TYPE) ->
                displayContent(CONSENTS_DBSA_EDAD_AGREEMENT_TITLE) // key: "consents_14_19_agreement_title"

            // DBSA only → 14 text
            else ->
                displayContent(CONSENTS_DBSA_AGREEMENT_TITLE) // key: "consents_14_agreement_title"
        }

        // EDAD (19) only → 19 text (there’s no combined EDCA+EDAD case)
        EDAD_TYPE -> displayContent(CONSENTS_EDAD_AGREEMENT_TITLE) // key: "consents_19_agreement_title"

        else -> StringUtils.EMPTY
    }
}
