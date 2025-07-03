interface ManageAlertsBusinessLogic {

    fun buildAlertConfigByCategory(
        configMapByCategoryId: Map<String, List<ManageAlertsConfigData>>,
        subscriptions: List<AlertSubscriptionApiData>
    ): Map<String, List<ManageAlertsConfigSubscription>>

    fun mapAlertConfigsToSubscriptions(
        configList: List<ManageAlertsConfigData>,
        subscriptions: List<AlertSubscriptionApiData>
    ): List<ManageAlertsConfigSubscription>

    fun buildAlertSubscriptionConfig(
        config: ManageAlertsConfigData,
        allConfigsInCategory: List<ManageAlertsConfigData>,
        apiSubscriptions: List<AlertSubscriptionApiData>
    ): ManageAlertsConfigSubscription

    fun getEligibleAccountsForAlert(
        alertConfig: ManageAlertsConfigSubscription,
        accounts: List<AccountSummaryApiData>
    ): List<AccountSummaryApiData>
}

class ManageAlertsBusinessLogicImpl : ManageAlertsBusinessLogic {

    override fun buildAlertConfigByCategory(
        configMapByCategoryId: Map<String, List<ManageAlertsConfigData>>,
        subscriptions: List<AlertSubscriptionApiData>
    ): Map<String, List<ManageAlertsConfigSubscription>> {
        return configMapByCategoryId.mapValues { (categoryId, configs) ->
            mapAlertConfigsToSubscriptions(configs, subscriptions)
        }
    }

    override fun mapAlertConfigsToSubscriptions(
        configList: List<ManageAlertsConfigData>,
        subscriptions: List<AlertSubscriptionApiData>
    ): List<ManageAlertsConfigSubscription> {
        return configList.map { config ->
            buildAlertSubscriptionConfig(config, configList, subscriptions)
        }
    }

    override fun buildAlertSubscriptionConfig(
        config: ManageAlertsConfigData,
        allConfigsInCategory: List<ManageAlertsConfigData>,
        apiSubscriptions: List<AlertSubscriptionApiData>
    ): ManageAlertsConfigSubscription {
        val matchingSubscriptions = apiSubscriptions.filter {
            it.purposeCode == config.purposeCode
        }

        val totalSubscriptions = allConfigsInCategory.count {
            it.categoryId == config.categoryId
        }

        val activeSubscriptions = allConfigsInCategory.count { configItem ->
            configItem.categoryId == config.categoryId &&
            (
                configItem.alwaysOn ||
                apiSubscriptions.any { sub ->
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

    override fun getEligibleAccountsForAlert(
        alertConfig: ManageAlertsConfigSubscription,
        accounts: List<AccountSummaryApiData>
    ): List<AccountSummaryApiData> {
        val qualifiers = alertConfig.qualifiers
        return if (qualifiers == null) {
            accounts
        } else {
            accounts.filter { it.category in qualifiers }
        }
    }
}
