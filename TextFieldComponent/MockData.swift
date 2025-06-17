private fun buildAlertSettingsState(configData: AlertSettingsConfigData): ManageAlertsAlertSettingsUiState {
    val preferenceDetails = configData
        .selectedAlertPreferenceData
        .subscriptions
        ?.flatMap { it.preferenceDetailDataList }
        ?.associateBy { it.deliveryMethod } ?: emptyMap()

    val isAnySubscriptionActive = configData
        .selectedAlertPreferenceData
        .subscriptions
        ?.any { it.active == true } == true

    val isAlertAlwaysOn = configData.selectedAlertPreferenceData.alwaysOn
    val purposeCode = configData.selectedAlertPreferenceData.purposeCode
    val thresholdValue = configData.selectedAlertPreferenceData.subscriptions
        ?.firstOrNull { it.purposeCode == purposeCode }
        ?.thresholdData
        ?.thresholdValue

    return ManageAlertsAlertSettingsUiState(
        alertSettingsData = configData,
        alertContactPreferences = preferenceDetails,
        alertFormVisible = isAnySubscriptionActive || isAlertAlwaysOn,
        alertInputFieldText = thresholdValue
    )
}
