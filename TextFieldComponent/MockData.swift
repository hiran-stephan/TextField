un ManageAlertsConfigSubscription.getInitialAlertContactPreferences(): Map<String, PreferenceDetailData> {
    return subscriptions
        ?.flatMap { it.preferenceDetailDataList }
        ?.associateBy { it.deliveryMethod } ?: emptyMap()
}

fun ManageAlertsConfigSubscription.isAlertFormVisible(): Boolean {
    val isAnySubscriptionActive = subscriptions?.any { it.active == true } == true
    return isAnySubscriptionActive || alwaysOn
}

fun ManageAlertsConfigSubscription.getInitialThresholdValue(): String? {
    return subscriptions
        ?.firstOrNull { it.purposeCode == purposeCode }
        ?.thresholdData
        ?.thresholdValue
}

val alertPreference =
    _manageAlertsAlertSettingsUiState.value.alertSettingsData
        ?.selectedAlertPreferenceData
        ?.subscriptions
        ?.firstOrNull { subscription ->
            if (accountId != null) {
                subscription.purposeCode == purposeCode &&
                subscription.productData?.productNumber == accountId
            } else {
                subscription.purposeCode == purposeCode
            }
        }

override suspend fun updateAlert(
    referenceId: String,
    updateAlertSubscriptionRequestApiDataList: UpdateAlertSubscriptionRequestApiDataList,
): Boolean {
    return builder.safeClientCall(referenceId) {
        client.put {
            url {
                path(API_ALERTS)
                appendSessionToken()
            }
            setBody(updateAlertSubscriptionRequestApiDataList)
        }
    }
}
