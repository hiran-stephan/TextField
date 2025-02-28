private fun getErrorMessage(code: String): String =
    messageCatalogue.formatErrorForNativeAlert(code)

private fun getConsentDocumentErrorMessage(consentData: ConsentData): String {
    if (!isConsentValidationFailed || consentData.isReviewed) {
        return ""
    }

    return when (consentData.consentType) {
        BDSA_TYPE -> getErrorMessage(DBSA_NOT_READ)
        EDCA_TYPE -> getErrorMessage(EDCA_NOT_READ)
        else -> CONSENT_TEXT_UNAVAILABLE
    }
}

private fun getCheckboxConsentErrorMessage(): String {
    return if (isConsentValidationFailed && isConsentChecked) {
        getErrorMessage(CHECKBOX_NOT_CHECKED)
    } else {
        ""
    }
}

// Constants for better readability
private const val CONSENT_TEXT_UNAVAILABLE = "Consent text not available"
