private fun getConsentText(consentType: String): String {
    return when {
        // EDCA (13) – always its own section, checkbox path
        consentType == EDCA_TYPE ->
            displayContent(ContentConstants.CONSENTS_13_AGREEMENT_TITLE)

        // DBSA (14) or EDAD (19) – when BOTH are shown in the same section
        (consentType == DBSA_TYPE || consentType == EDAD_TYPE) && consentCount > 1 ->
            displayContent(ContentConstants.CONSENTS_14_19_AGREEMENT_TITLE)

        // Single DBSA (14)
        consentType == DBSA_TYPE ->
            displayContent(ContentConstants.CONSENTS_14_AGREEMENT_TITLE)

        // Single EDAD (19)
        consentType == EDAD_TYPE ->
            displayContent(ContentConstants.CONSENTS_19_AGREEMENT_TITLE)

        else -> StringUtils.EMPTY
    }
}
