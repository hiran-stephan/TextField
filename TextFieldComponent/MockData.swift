fun associateAlertCategories(
    config: ManageAlertsConfigData,
    allConfigsForCategory: List<ManageAlertsConfigData>,
    subscriptions: List<AlertSubscriptionApiData>
): ManageAlertsConfigSubscription

override fun associateAlertCategories(
    config: ManageAlertsConfigData,
    allConfigsForCategory: List<ManageAlertsConfigData>,
    subscriptions: List<AlertSubscriptionApiData>
): ManageAlertsConfigSubscription {
    val matchingSubscriptions = subscriptions.filter { it.purposeCode == config.purposeCode }

    return ManageAlertsConfigSubscription(
        name = config.name,
        alwaysOn = config.alwaysOn,
        purposeCode = config.purposeCode,
        categoryId = config.categoryId,
        subCategoryId = config.subCategoryId,
        alertType = config.alertType,
        contactTypes = config.contactTypes,
        inputField = config.inputField,
        qualifiers = config.qualifiers,
        subscriptions = matchingSubscriptions.map { it.toAlertSubscriptionData() },
        totalSubscriptions = allConfigsForCategory.size,
        activeSubscriptions = matchingSubscriptions.count { it.active == true }
    )
}

val totalSubscriptions = allConfigsForCategory.count { it.categoryId == config.categoryId }

