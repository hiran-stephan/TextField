internal fun saveAlertPreference() {
    val uiState = _manageAlertsAlertSettingsUiState.value
    val alertPreference = uiState.alertSettingsData?.selectedAlertPreferenceData
    val alertFormVisible = uiState.alertFormVisible
    val alertInputFieldText = uiState.alertInputFieldText
    val selectedContacts = uiState.alertContactPreferences.values.filter { it.selected }
    val purposeCode = alertPreference?.purposeCode

    when {
        !alertFormVisible -> handleDeletePreference(alertPreference, purposeCode)

        alertPreference != null -> handleUpdatePreference(alertPreference, alertInputFieldText, selectedContacts)

        purposeCode != null -> handleCreatePreference(purposeCode, alertInputFieldText, selectedContacts)
    }
}

private fun handleDeletePreference(alertPreference: AlertSubscriptionData?, purposeCode: String?) {
    val alertId = alertPreference?.id
    if (alertId != null && purposeCode != null) {
        deleteAlertPreferences(alertId = alertId, purposeCode = purposeCode)
    }
}

private fun handleUpdatePreference(
    alertPreference: AlertSubscriptionData,
    inputText: String,
    selectedContacts: List<AlertContactPreferenceData>
) {
    val updatedPreference = alertPreference.copy(
        thresholdData = alertPreference.thresholdData?.copy(thresholdValue = inputText)
            ?: ThresholdData(thresholdId = null, thresholdValue = inputText),
        preferenceDetailDataList = selectedContacts
    )
    updateAlertPreferences(AlertsData(alertSubscriptionDataList = listOf(updatedPreference)))
}

private fun handleCreatePreference(
    purposeCode: String,
    inputText: String,
    selectedContacts: List<AlertContactPreferenceData>
) {
    val newSubscription = AlertSubscriptionData(
        purposeCode = purposeCode,
        thresholdData = ThresholdData(thresholdId = null, thresholdValue = inputText),
        preferenceDetailDataList = selectedContacts
    )
    createAlertPreferences(
        alertSubscriptionData = newSubscription,
        accountId = alertSettingsNavigationItem.accountId
    )
}

