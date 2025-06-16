val selectedPreference = _manageAlertsAlertSettingsUiState.value.alertSettingsData?.selectedAlertPreferenceData
val purposeCode = selectedPreference?.purposeCode

?.firstOrNull { it.purposeCode == purposeCode }
?.run {
    copy(
        thresholdData = thresholdData?.copy(
            thresholdValue = alertInputFieldText
        ) ?: ThresholdData(null, alertInputFieldText),
        preferenceDetailDataList = alertContactPreferences.values.filter { it.selected }
    )
}

if (!alertFormVisible)
    
    else if (alertFormVisible && alertContactPreferences.isNotEmpty()) {
    
    
    if (!alertFormVisible && purposeCode != null) {
        deleteAlertPreferences(...)
        return
    }
    
    updatedAlertSubscription?.let {
        createAlertPreferences(
            alertSubscriptionData = it,
            accountId = alertSettingsNavigationItem.accountId ?: StringUtils.EMPTY
        )
    }
