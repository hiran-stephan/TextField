private fun getSectionStepIndicatorText(consentType: String): String =
    getStepIndicatorText(consentType, isAccessibility = false)

private fun getSectionStepIndicatorAccessibilityText(consentType: String): String =
    getStepIndicatorText(consentType, isAccessibility = true)

private fun getStepIndicatorText(consentType: String, isAccessibility: Boolean): String {
    return when (consentType) {
        DBSA_TYPE -> if (consentCount == 1) {
            if (isAccessibility) stepOneIconAccessibilityText else stepOneIconText
        } else {
            if (isAccessibility) stepTwoIconAccessibilityText else stepTwoIconText
        }
        EDCA_TYPE -> if (isAccessibility) stepOneIconAccessibilityText else stepOneIconText
        else -> StringUtils.EMPTY
    }
}
