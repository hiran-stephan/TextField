private fun getConsentDocumentErrorMessage(consentData: ConsentData): String {
    if (!isConsentValidationFailed || consentData.isReviewed) return StringUtils.EMPTY

    return when (consentData.consentType) {
        DBSA_TYPE -> messageCatalogue.formatErrorForGlobalAlertMessage(DBSA_NOT_READ)
        EDCA_TYPE -> messageCatalogue.formatErrorForGlobalAlertMessage(EDCA_NOT_READ)
        EDAD_TYPE -> messageCatalogue.formatErrorForGlobalAlertMessage(EDAD_NOT_READ) // NEW
        else      -> StringUtils.EMPTY
    }
}

private fun getConsentDocumentErrorCode(consentData: ConsentData): String {
    if (!isConsentValidationFailed || consentData.isReviewed) return StringUtils.EMPTY

    return when (consentData.consentType) {
        DBSA_TYPE -> "#{$DBSA_NOT_READ}"
        EDCA_TYPE -> "#{$EDCA_NOT_READ}"
        EDAD_TYPE -> "#{$EDAD_NOT_READ}" // NEW => "#0213"
        else      -> StringUtils.EMPTY
    }
}
