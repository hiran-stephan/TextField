class ConsentSectionPresenter {
    private val isCheckboxChecked: Boolean = false
    private val consentData: Map<String, List<ConsentData>> = emptyMap() // Now a Map of consentType -> List<ConsentData>
    private val contentFile: ContentFile? = null
    private val locale: Locale

    private fun displayContent(
        key: String,
        forAccessibility: Boolean = false
    ): String = contentFile?.findContentValue(key, locale.lang, forAccessibility) ?: ""

    val title = displayContent(key = ContentConstants.STEP_1_TITLE_TEXT)
    val pendingReviewStatusPillText: String = displayContent(ContentConstants.CONSENTS_DOCUMENT_PENDING_REVIEW_STATUS_PILL_TEXT)
    val reviewedStatusPillText: String = displayContent(ContentConstants.CONSENTS_DOCUMENT_REVIEWED_STATUS_PILL_TEXT)

    val consentDocuments = consentData.flatMap { (type, consents) ->
        consents.map { consent ->
            ConsentDocumentData(
                documentTitle = consent.consentName,
                documentType = consent.consentType,
                documentVersion = consent.consentVersion,
                documentPath = consent.consentPath,
                isDocumentReviewed = consent.isReviewed,
                documentError = consent.error ?: "",
                documentBadgeText = if (consent.isReviewed) reviewedStatusPillText else pendingReviewStatusPillText
            )
        }
    }

    val consentText = displayContent(key = ContentConstants.CONSENTS_CHECKBOX_TEXT_FOR_EDCA_AGREEMENT_ONLY)
    val isConsentChecked: Boolean = isCheckboxChecked
    val consentErrorMessage: String = ""
}
