fun getSubmitConsentFooterText(consentTypes: List<String>): String {
    val hasEdca = consentTypes.any { it == EDCA_TYPE }
    val hasDbsa = consentTypes.any { it == DBSA_TYPE }
    val hasEdad = consentTypes.any { it == EDAD_TYPE }
    return if (!hasEdca && (hasDbsa || hasEdad)) {
        displayContent(ContentConstants.CONSENTS_SUBMIT_CONSENT_FOOTER) // key must exist in JSON
    } else StringUtils.EMPTY
}
