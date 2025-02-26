class ConsentSectionPresenter(
    private val data: ConsentsData?,
    private val contentFile: ContentFile?,
    private val locale: Locale
) {
    // Computed property that updates sections dynamically
    val sections: List<ConsentSection>
        get() = data?.sections?.map { section ->
            section.copy(
                title = getSectionTitle(section.consentData.consentType),
                consentData = section.consentData.copy(
                    consentText = getConsentText(section.consentData.consentType),
                    isConsentProvided = isConsentRequired(section.consentData.consentType)
                ),
                consentDocuments = section.consentDocuments // Keeps the same documents
            )
        } ?: emptyList()

    // Fetch section title based on ConsentType
    private fun getSectionTitle(consentType: String): String {
        return when (consentType) {
            "13" -> displayContent(ContentConstants.STEP_1_TITLE_TEXT)
            "14" -> displayContent(ContentConstants.STEP_2_TITLE_TEXT)
            else -> "Unknown Consent Type"
        }
    }

    // Fetch Consent Text based on ConsentType
    private fun getConsentText(consentType: String): String {
        return when (consentType) {
            "13" -> displayContent(ContentConstants.CONSENTS_CHECKBOX_TEXT_FOR_BDSA_AGREEMENT_WHEN_EDCA_AGREEMENT_AVAILABLE)
            "14" -> displayContent(ContentConstants.CONSENTS_CHECKBOX_TEXT_FOR_EDCA_AGREEMENT_ONLY)
            else -> "Consent text not available"
        }
    }

    // Determine if consent is required based on ConsentType
    private fun isConsentRequired(consentType: String): Boolean {
        return when (consentType) {
            "13" -> true
            "14" -> false
            else -> false
        }
    }

    // Helper function to fetch localized content
    private fun displayContent(key: String, forAccessibility: Boolean = false): String {
        return contentFile?.findContentValue(key, locale.lang, forAccessibility) ?: "Content not found"
    }
}
