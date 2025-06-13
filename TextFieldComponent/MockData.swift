fun getThresholdValue(purposeCode: String): String? {
    return selectedAlertPreferenceData.subscriptions
        ?.firstOrNull { it.purposeCode == purposeCode }
        ?.threshold
        ?.thresholdValue
}

val alertInputFieldValue = getThresholdValue(purposeCode)


val id = subscriptions
        .flatMap { it.preferenceDetails }
        .firstOrNull { it.deliveryMethod == contactTypeName }
        ?.id
