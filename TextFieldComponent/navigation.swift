val consentDocuments = consentData2?.map { consent ->
    ConsentDocumentMapped(
        consentDocumentTitle = consent.consentName ?: "",
        consentDocumentType = consent.consentType ?: "",
        consentDocumentVersion = consent.consentVersion ?: "",
        consentDocumentPath = consent.consentPath ?: "",
        isConsentDocumentReviewed = consent.isReviewed ?: false,
        consentDocumentError = consent.error ?: "",
        consentDocumentBadgeText = if (consent.isReviewed == true) reviewedStatusPillText else pendingReviewStatusPillText
    )
} ?: emptyList()

data class ConsentDocumentMapped(
    val consentDocumentTitle: String,
    val consentDocumentType: String,
    val consentDocumentVersion: String,
    val consentDocumentPath: String,
    val isConsentDocumentReviewed: Boolean,
    val consentDocumentError: String,
    val consentDocumentBadgeText: String
)
