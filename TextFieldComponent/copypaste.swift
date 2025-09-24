val groupedConsents =
  consentsData
    .updateIfAccepted(consentActionState.value.acceptedConsents)
    .sortByConsentType()
    .groupBy { it.bucketType() }

// ConsentsHelper.kt (or near existing helpers)
fun ConsentData.bucketType(): String = when (consentType) {
    EDCA_TYPE -> EDCA_TYPE                  // EDCA is its own section
    DBSA_TYPE, EDAD_TYPE -> DBSA_TYPE       // DBSA + EDAD in one section
    else -> consentType
}


// ConsentsHelper.kt
fun List<ConsentData>.sortByConsentType(): List<ConsentData> =
    this.sortedBy {
        when (it.consentType) {
            EDCA_TYPE -> 0
            DBSA_TYPE, EDAD_TYPE -> 1
            else -> 2
        }
    }

// ConsentSectionPresenter.kt

private fun getSectionTitle(consentType: String): String = when (consentType) {
    DBSA_TYPE, EDAD_TYPE -> stepTwoTitleText    // same section as in Figma
    EDCA_TYPE -> stepOneTitleText
    else -> StringUtils.EMPTY
}

private fun getStepIndicatorText(consentType: String, isAccessibility: Boolean): String =
    when (consentType) {
        DBSA_TYPE, EDAD_TYPE -> if (isAccessibility) stepTwoIconAccessibilityText else stepTwoIconText
        EDCA_TYPE            -> if (isAccessibility) stepOneIconAccessibilityText else stepOneIconText
        else -> StringUtils.EMPTY
    }

private fun getConsentRequired(consentType: String): Boolean = when (consentType) {
    EDCA_TYPE -> true                  // checkbox required
    DBSA_TYPE, EDAD_TYPE -> false      // per Figma: single “Submit” consent, no checkbox
    else -> false
}



private fun getConsentDocumentErrorMessage(consentData: ConsentData): String =
    if (!isConsentValidationFailed || consentData.isReviewed) StringUtils.EMPTY else when (consentData.consentType) {
        DBSA_TYPE -> messageCatalogue.formatErrorForGlobalAlertMessage(DBSA_NOT_READ)
        EDCA_TYPE -> messageCatalogue.formatErrorForGlobalAlertMessage(EDCA_NOT_READ)
        EDAD_TYPE -> messageCatalogue.formatErrorForGlobalAlertMessage(EDAD_NOT_READ) // NEW
        else      -> CONSENT_TEXT_UNAVAILABLE
    }

private fun getConsentDocumentErrorCode(consentData: ConsentData): String =
    if (!isConsentValidationFailed || consentData.isReviewed) StringUtils.EMPTY else when (consentData.consentType) {
        DBSA_TYPE -> "{$DBSA_NOT_READ}"
        EDCA_TYPE -> "{$EDCA_NOT_READ}"
        EDAD_TYPE -> "{$EDAD_NOT_READ}"   // NEW
        else      -> CONSENT_TEXT_UNAVAILABLE
    }



