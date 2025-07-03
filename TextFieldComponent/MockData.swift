package com.cibc.managealerts.domain.usecases

import com.cibc.managealerts.data.models.*
import com.cibc.managealerts.remote.models.*

/**
 * Business logic interface for mapping alert configurations with API subscriptions
 * and filtering eligible accounts for alert delivery.
 */
@OpenForMockkery
interface ManageAlertsBusinessLogic {

    /**
     * Builds a map of alert configuration subscriptions grouped by categoryId.
     *
     * @param configMapByCategoryId The map of alert config data grouped by categoryId.
     * @param subscriptions The list of alert subscriptions received from the API.
     * @return A map of categoryId to a list of enriched alert config subscriptions.
     */
    fun buildAlertConfigByCategory(
        configMapByCategoryId: Map<String, List<ManageAlertsConfigData>>,
        subscriptions: List<AlertSubscriptionApiData>
    ): Map<String, List<ManageAlertsConfigSubscription>>

    /**
     * Maps a list of alert configs to enriched subscription data.
     *
     * @param configList A flat list of alert configuration data.
     * @param subscriptions The list of alert subscriptions received from the API.
     * @return A list of enriched alert configuration subscriptions.
     */
    fun mapAlertConfigsToSubscriptions(
        configList: List<ManageAlertsConfigData>,
        subscriptions: List<AlertSubscriptionApiData>
    ): List<ManageAlertsConfigSubscription>

    /**
     * Builds a single enriched alert subscription configuration object.
     *
     * @param config The alert configuration being enriched.
     * @param allConfigsInCategory All config items that belong to the same category.
     * @param apiSubscriptions The list of alert subscriptions received from the API.
     * @return The enriched alert configuration subscription.
     */
    fun buildAlertSubscriptionConfig(
        config: ManageAlertsConfigData,
        allConfigsInCategory: List<ManageAlertsConfigData>,
        apiSubscriptions: List<AlertSubscriptionApiData>
    ): ManageAlertsConfigSubscription

    /**
     * Filters the list of accounts based on the qualifiers defined in the alert config.
     *
     * @param alertConfig The enriched alert config containing qualifiers.
     * @param accounts The list of all available accounts.
     * @return A filtered list of accounts eligible for the given alert config.
     */
    fun getEligibleAccountsForAlert(
        alertConfig: ManageAlertsConfigSubscription,
        accounts: List<AccountSummaryApiData>
    ): List<AccountSummaryApiData>
}



package com.cibc.managealerts.domain.usecases

import com.cibc.managealerts.data.models.*
import com.cibc.managealerts.remote.models.*

/**
 * Implementation of ManageAlertsBusinessLogic.
 * Provides logic to combine alert config with subscriptions and account eligibility filtering.
 */
class ManageAlertsBusinessLogicImpl : ManageAlertsBusinessLogic {

    /**
     * Groups and maps alert configs by categoryId with corresponding API subscriptions.
     */
    override fun buildAlertConfigByCategory(
        configMapByCategoryId: Map<String, List<ManageAlertsConfigData>>,
        subscriptions: List<AlertSubscriptionApiData>
    ): Map<String, List<ManageAlertsConfigSubscription>> {
        return configMapByCategoryId.mapValues { (_, configs) ->
            mapAlertConfigsToSubscriptions(configs, subscriptions)
        }
    }

    /**
     * Maps each alert config in the list to its enriched subscription representation.
     */
    override fun mapAlertConfigsToSubscriptions(
        configList: List<ManageAlertsConfigData>,
        subscriptions: List<AlertSubscriptionApiData>
    ): List<ManageAlertsConfigSubscription> {
        return configList.map { config ->
            buildAlertSubscriptionConfig(config, configList, subscriptions)
        }
    }

    /**
     * Builds enriched subscription details for a single alert config.
     * Calculates matching subscriptions, total, and active counts.
     */
    override fun buildAlertSubscriptionConfig(
        config: ManageAlertsConfigData,
        allConfigsInCategory: List<ManageAlertsConfigData>,
        apiSubscriptions: List<AlertSubscriptionApiData>
    ): ManageAlertsConfigSubscription {

        // Match subscriptions by purposeCode
        val matchingSubscriptions = apiSubscriptions.filter {
            it.purposeCode == config.purposeCode
        }

        // Total alert configs for this category
        val totalSubscriptions = allConfigsInCategory.count {
            it.categoryId == config.categoryId
        }

        // Active = alwaysOn OR matching API subscription marked active
        val activeSubscriptions = allConfigsInCategory.count { configItem ->
            configItem.categoryId == config.categoryId &&
                (configItem.alwaysOn || apiSubscriptions.any { sub ->
                    sub.purposeCode == configItem.purposeCode && sub.active == true
                })
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

    /**
     * Filters accounts eligible for a given alert config based on its qualifiers.
     */
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
