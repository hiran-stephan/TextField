val alertContactPreferences: Map<String, PreferenceDetailData> = emptyMap()

val preferenceDetailsMap = ...
    ?.map { it.toPreferenceDetailData() }
    ?.associateBy { it.deliveryMethod } ?: emptyMap()

_manageAlertsAlertSettingsUiState.update {
    it.copy(alertContactPreferences = preferenceDetailsMap)
}

val existingMap = state.alertContactPreferences.toMutableMap()
existingMap[deliveryMethod] = PreferenceDetailData(
    id = existingMap[deliveryMethod]?.id,
    deliveryMethod = deliveryMethod,
    selected = selected
)
state.copy(alertContactPreferences = existingMap)


val selected = state.alertContactPreferences["SMS"]?.selected


val selectedPrefs = state.alertContactPreferences.values.filter { it.selected }


val alertSubscriptionData = _manageAlertsAlertSettingsUiState.value
    .alertSettingsData
    ?.selectedAlertPreferenceData
    ?.subscriptions
    ?.firstOrNull { it.purposeCode == purposeCode }


// Get the matching subscription
    val updatedSubscriptions = uiState.alertSettingsData
        ?.selectedAlertPreferenceData
        ?.subscriptions
        ?.map { subscription ->
            if (subscription.purposeCode == purposeCode) {
                subscription.copy(
                    thresholdData = subscription.thresholdData?.copy(
                        thresholdValue = alertInputFieldText
                    ) ?: ThresholdData(thresholdId = null, thresholdValue = alertInputFieldText),
                    preferenceDetailDataList = alertContactPreferences.values.toList()
                )
            } else {
                subscription
            }
        }
