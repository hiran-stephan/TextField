override fun associateAlertCategories(
    config: ManageAlertsConfigData,
    allConfigsForCategory: List<ManageAlertsConfigData>,
    subscriptions: List<AlertSubscriptionApiData>
): ManageAlertsConfigSubscription {
    val matchingSubscriptions = subscriptions.filter { it.purposeCode == config.purposeCode }

    val totalSubscriptions = allConfigsForCategory.count { it.categoryId == config.categoryId }

    val activeSubscriptions = allConfigsForCategory.count { configItem ->
        configItem.categoryId == config.categoryId && (
            configItem.alwaysOn || subscriptions.any { sub ->
                sub.purposeCode == configItem.purposeCode && sub.active == true
            }
        )
    }

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
        totalSubscriptions = totalSubscriptions,
        activeSubscriptions = activeSubscriptions
    )
}
