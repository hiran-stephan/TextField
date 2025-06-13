val preferenceDetailsList = alertSettingsData
    .selectedAlertPreferenceData
    .subscriptions
    ?.flatMap { it.preferenceDetails }
    ?.map { it.toPreferenceDetailData() }
    ?: emptyList()

List<PreferenceDetailData>
