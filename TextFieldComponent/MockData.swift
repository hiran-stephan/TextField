internal fun saveAlertPreference(
    alertFormVisible: Boolean,
    alertInputFieldText: String,
    selectedContactTypes: List<AlertContactPreferenceData>,
    selectedAlertPreferenceData: AlertSettingsData?,
    alertSettingsData: AlertSettingsData?,
    accountId: String
)


val purposeCode = selectedAlertPreferenceData?.purposeCode
val alertPreference = alertSettingsData
    ?.selectedAlertPreferenceData
    ?.subscriptions
    ?.firstOrNull { it.purposeCode == purposeCode }

when {
    !alertFormVisible ->
        handleDeletePreference(alertPreference?.id, purposeCode)

    alertPreference != null ->
        handleUpdatePreference(alertPreference, alertInputFieldText, selectedContactTypes)

    purposeCode != null ->
        handleCreatePreference(purposeCode, alertInputFieldText, selectedContactTypes, accountId)
}


saveAlertPreference(
    alertFormVisible = uiState.alertFormVisible,
    alertInputFieldText = uiState.alertInputFieldText,
    selectedContactTypes = uiState.alertContactPreferences.values.filter { it.selected },
    selectedAlertPreferenceData = uiState.alertSettingsData?.selectedAlertPreferenceData,
    alertSettingsData = uiState.alertSettingsData,
    accountId = alertSettingsNavigationItem.accountId
)

