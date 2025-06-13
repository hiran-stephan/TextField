fun getThresholdValue(purposeCode: String): String? {
    return selectedAlertPreferenceData.subscriptions
        ?.firstOrNull { it.purposeCode == purposeCode }
        ?.threshold
        ?.thresholdValue
}

val alertInputFieldValue = getThresholdValue(purposeCode)

