{
  "consents": {
    "consents_13_agreement_title": "I/We read and agree to the CIBC Bank USA Electronic Disclosure Consent Agreement and consent to the delivery of electronic disclosures as provided in that agreement. I/We acknowledge receiving the statement of hardware and software requirements contained in that agreement. I/We agree to provide CIBC US with a current email address for sending electronic communications to me/us.",

    "consents_14_agreement_title": "By selecting 'Submit' I/We acknowledge receiving the CIBC Bank USA Digital Services Agreement and agree to its terms and conditions.",

    "consents_19_agreement_title": "By selecting 'Submit' I/We acknowledge receiving the CIBC Bank USA Electronic Documents Agreement and Disclosure and agree to its terms and conditions.",

    "consents_14_19_agreement_title": "By selecting 'Submit' I/We acknowledge receiving the CIBC Bank USA Digital Services Agreement and the Electronic Documents Agreement and Disclosure, and agree to the terms and conditions in those agreements."
  }
}


const val CONSENTS_13_AGREEMENT_TITLE = "consents_13_agreement_title"
const val CONSENTS_14_AGREEMENT_TITLE = "consents_14_agreement_title"
const val CONSENTS_19_AGREEMENT_TITLE = "consents_19_agreement_title"
const val CONSENTS_14_19_AGREEMENT_TITLE = "consents_14_19_agreement_title"


private fun getConsentText(consentType: String, groupedConsents: List<String>): String {
    return when {
        consentType.equals(EDCA_TYPE, ignoreCase = true) ->
            displayContent(CONSENTS_13_AGREEMENT_TITLE)

        groupedConsents.containsAll(listOf(DBSA_TYPE, EDAD_TYPE)) ->
            displayContent(CONSENTS_14_19_AGREEMENT_TITLE)

        consentType.equals(DBSA_TYPE, ignoreCase = true) ->
            displayContent(CONSENTS_14_AGREEMENT_TITLE)

        consentType.equals(EDAD_TYPE, ignoreCase = true) ->
            displayContent(CONSENTS_19_AGREEMENT_TITLE)

        else -> ""
    }
}


