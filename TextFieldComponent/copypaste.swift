private fun getConsentText(consentType: String): String {
    // Types present in THIS section
    val types = consentData.map { it.consentType }.toSet()

    return when {
        // EDCA + DBSA (no EDAD) → use EDCA text (13)
        types.contains(EDCA_TYPE) && types.contains(DBSA_TYPE) && !types.contains(EDAD_TYPE) ->
            displayContent(CONSENTS_13_AGREEMENT_TITLE)

        // EDCA alone → 13 text
        types.size == 1 && types.contains(EDCA_TYPE) ->
            displayContent(CONSENTS_13_AGREEMENT_TITLE)

        // DBSA + EDAD (no EDCA) → combined 14+19 text
        types.contains(DBSA_TYPE) && types.contains(EDAD_TYPE) && !types.contains(EDCA_TYPE) ->
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
