data class ConsentsData(
    val sections: List<ConsentSection>
)

data class ConsentSection(
    val title: String,
    val consentData: ConsentData,
    val consentDocuments: List<ConsentDocumentData>
)

data class ConsentData(
    val consentText: String,
    val isConsentProvided: Boolean = false,
    val consentError: String? = null
)

data class ConsentDocumentData(
    val consentName: String,
    val consentType: String,
    val consentVersion: String,
    val consentPath: String,
    val isReviewed: Boolean = false,
    val error: String? = null
)
