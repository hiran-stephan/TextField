fun ManageAlertsConfigSubscription.isAlertFormVisible(accountNumber: String?): Boolean {
    val isAnySubscriptionActive = if (accountNumber != null) {
        subscriptions
            ?.filter { it.productData?.productNumber == accountNumber }
            ?.any { it.active == true } == true
    } else {
        subscriptions?.any { it.active == true } == true
    }

    return isAnySubscriptionActive || alwaysOn
}
