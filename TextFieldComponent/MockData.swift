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
