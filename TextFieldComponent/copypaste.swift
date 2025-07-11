fun ManageAlertsConfigSubscription.isAlertFormVisible(accountNumber: String?): Boolean {
    val isAnySubscriptionActive = subscriptions
        ?.filter { it.productData?.productNumber == accountNumber }
        ?.any { it.active == true } == true

    return isAnySubscriptionActive || alwaysOn
}
