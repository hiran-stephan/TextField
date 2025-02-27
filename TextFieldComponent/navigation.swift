fun getSectionTitle(consentType: String): String {
      return when (consentType) {
          "13" -> displayContent(ContentConstants.STEP_1_TITLE_TEXT)
          "14" -> displayContent(ContentConstants.STEP_2_TITLE_TEXT)
          else -> "Unknown Consent Type"
      }
  }

  // Fetch Consent Text based on ConsentType
  fun getConsentText(consentType: String): String {
      return when (consentType) {
          "13" -> displayContent(ContentConstants.CONSENTS_CHECKBOX_TEXT_FOR_BDSA_AGREEMENT_WHEN_EDCA_AGREEMENT_AVAILABLE)
          "14" -> displayContent(ContentConstants.CONSENTS_CHECKBOX_TEXT_FOR_EDCA_AGREEMENT_ONLY)
          else -> "Consent text not available"
      }
  }

  // Check if Consent is required based on ConsentType
  fun isConsentRequired(consentType: String): Boolean {
      return when (consentType) {
          "13" -> true
          "14" -> false
          else -> false
      }
  }
val consentType: String = consentData.firstOrNull()?.consentType ?: ""
