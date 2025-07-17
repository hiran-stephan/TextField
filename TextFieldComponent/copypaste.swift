/**
 * Returns a list of [AlertSubCategoryPreference] sorted according to a predefined subcategory order.
 *
 * @param data A map of subcategory IDs to their corresponding list of [ManageAlertsConfigSubscription] items.
 * @return A sorted list of [AlertSubCategoryPreference] based on predefined subcategory order,
 *         or null if the input data is null.
 */
override fun getOrderedCategoryPreferenceData(
    data: Map<String, List<ManageAlertsConfigSubscription>>?
): List<AlertSubCategoryPreference>? {
    ...
}


/**
 * Retrieves a sorted list of [AlertSubCategoryPreference] from the provided subcategory configuration map.
 *
 * Delegates to [ManageAlertsBusinessLogic.getOrderedCategoryPreferenceData] to apply consistent sorting logic.
 *
 * @param data A map of subcategory IDs to their corresponding list of [ManageAlertsConfigSubscription].
 * @return A sorted list of [AlertSubCategoryPreference], or null if input is null or empty.
 */
fun getCategoryPreferenceData(
    data: Map<String, List<ManageAlertsConfigSubscription>>
): List<AlertSubCategoryPreference>? {
    return alertsBusinessLogic.getOrderedCategoryPreferenceData(data = data)
}
