"consents_document_error_code_13": { "en": "0050" },  // EDCA
"consents_document_error_code_14": { "en": "0045" },  // DBSA
"consents_document_error_code_19": { "en": "0213" }   // EDAD

// Read the error code for a consent type from content; empty if missing
private fun documentErrorCode(consentType: String): String =
    contentFile?.findContentValue(
        key = "consents_document_error_code_${consentType}",
        locale = locale.lang,
        forAccessibility = false
    ).orEmpty()

private fun getConsentDocumentErrorMessage(consentData: ConsentData): String {
    if (!isConsentValidationFailed || consentData.isReviewed) return StringUtils.EMPTY
    val code = documentErrorCode(consentData.consentType)
    return if (code.isNotBlank())
        messageCatalogue.formatErrorForGlobalAlertMessage(code)
    else
        StringUtils.EMPTY
}

private fun getConsentDocumentErrorCode(consentData: ConsentData): String {
    if (!isConsentValidationFailed || consentData.isReviewed) return StringUtils.EMPTY
    val code = documentErrorCode(consentData.consentType)
    return if (code.isNotBlank()) "#$code" else StringUtils.EMPTY
}

