private val isAlertTypeAccount = alertsConfigSubscription.aLertType?.uppercase() == ALERT_TYPE_ACCOUNT

private val alertSubscriptionApiData =
    if (isAlertTypeAccount) {
        alertsConfigSubscription.subscriptions
            ?.firstOrNull { it.productData != null && it.active == true }
    } else {
        alertsConfigSubscription.subscriptions?.firstOrNull()
    }

private val isAlertActive = alertSubscriptionApiData?.active ?: false
