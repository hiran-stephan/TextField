private fun getConsentText(consentType: String): String {
    // Types present in THIS section
    val types = consentData.map { it.consentType }.toSet()

    return when {
        // If EDCA present in this section (it’s its own section anyway) -> always 13 text
        types.contains(EDCA_TYPE) ->
            displayContent(CONSENTS_13_AGREEMENT_TITLE)

        // DBSA + EDAD together (no EDCA) -> combined 14+19 text
        types.contains(DBSA_TYPE) && types.contains(EDAD_TYPE) ->
            displayContent(CONSENTS_14_19_AGREEMENT_TITLE)

        // DBSA only
        types.size == 1 && types.contains(DBSA_TYPE) ->
            displayContent(CONSENTS_14_AGREEMENT_TITLE)

        // EDAD only
        types.size == 1 && types.contains(EDAD_TYPE) ->
            displayContent(CONSENTS_19_AGREEMENT_TITLE)

        else -> StringUtils.EMPTY
    }
}


private fun consentRequired(consentType: String): Boolean {
    val types = consentData.map { it.consentType }.toSet()
    return when {
        // EDCA anywhere in this section -> checkbox required
        types.contains(EDCA_TYPE) -> true

        // DBSA only (no EDCA, no EDAD) -> checkbox required
        types.size == 1 && types.contains(DBSA_TYPE) -> true

        // EDCA + DBSA -> DBSA section has NO checkbox (EDCA section covers it)
        // DBSA + EDAD (no EDCA) -> NO checkbox
        else -> false
    }
}
