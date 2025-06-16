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

