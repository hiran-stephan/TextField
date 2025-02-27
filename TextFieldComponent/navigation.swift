class ConsentSectionPresenter(
    private val contentFile: ContentFile?,
    private val locale: Locale,
    private val consentData: List<ConsentData> = emptyList(),
    private val isCheckboxChecked: Boolean = false,
    private val isConsentError: Boolean = false
) {

    /** --- Public Properties Exposed to UI --- **/

    val consentType: String by lazy { consentData.firstOrNull()?.consentType.orEmpty() }
    val title: String by lazy { getSectionTitle(consentType) }
    val consentText: String by lazy { getConsentText(consentType) }
    val isConsentChecked: Boolean = isCheckboxChecked
    val isConsentRequired: Boolean = consentRequired(consentType)
    val consentErrorMessage: String by lazy { if (isConsentError) "consent error message" else "" }

    /** --- Consent Document Mapping --- **/
    
    val consentDocuments: List<ConsentDocumentData> = consentData.mapNotNull { consent ->
        consent.consentName?.let {
            ConsentDocumentData(
                documentTitle = it,
                documentType = consent.consentType,
                documentVersion = consent.consentVersion,
                documentPath = consent.consentPath,
                isDocumentReviewed = consent.isReviewed,
                documentError = consent.error.orEmpty(),
                documentBadgeText = if (consent.isReviewed) reviewedStatusPillText else pendingReviewStatusPillText
            )
        }
    }

    /** --- Private Properties --- **/

    private val pendingReviewStatusPillText: String by lazy {
        displayContent(ContentConstants.CONSENTS_DOCUMENT_PENDING_REVIEW_STATUS_PILL_TEXT)
    }
    private val reviewedStatusPillText: String by lazy {
        displayContent(ContentConstants.CONSENTS_DOCUMENT_REVIEWED_STATUS_PILL_TEXT)
    }

    private val stepOneIconText: String by lazy {
        displayContent(ContentConstants.STEP_1_ICON_TEXT)
    }
    private val stepTwoIconText: String by lazy {
        displayContent(ContentConstants.STEP_2_ICON_TEXT)
    }
    private val stepOneTitleText: String by lazy {
        displayContent(ContentConstants.STEP_1_TITLE_TEXT)
    }
    private val stepTwoTitleText: String by lazy {
        displayContent(ContentConstants.STEP_2_TITLE_TEXT)
    }

    /** --- Utility Methods (Private) --- **/

    private fun displayContent(key: String, forAccessibility: Boolean = false): String =
        contentFile?.findContentValue(key, locale.lang, forAccessibility).orEmpty()

    private fun getSectionTitle(consentType: String): String = when (consentType) {
        BDSA_TYPE -> stepOneIconText + stepOneTitleText
        EDCA_TYPE -> stepTwoIconText + stepTwoTitleText
        else -> "Unknown Consent Type"
    }

    private val consentTextMap = mapOf(
        BDSA_TYPE to ContentConstants.CONSENTS_CHECKBOX_TEXT_FOR_BDSA_AGREEMENT_WHEN_EDCA_AGREEMENT_AVAILABLE,
        EDCA_TYPE to ContentConstants.CONSENTS_CHECKBOX_TEXT_FOR_EDCA_AGREEMENT_ONLY
    )

    private fun getConsentText(consentType: String): String =
        displayContent(consentTextMap[consentType] ?: "Consent text not available")

    private val consentRequiredMap = mapOf(
        BDSA_TYPE to false,
        EDCA_TYPE to true
    )

    private fun consentRequired(consentType: String): Boolean =
        consentRequiredMap[consentType] ?: false
}
