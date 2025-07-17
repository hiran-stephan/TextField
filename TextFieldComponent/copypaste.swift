data class AlertSubCategoryPreference(
    val subCategoryId: String,
    val alerts: List<ManageAlertsConfigSubscription>
)

fun getOrderedCategoryPreferenceData(
    data: Map<String, List<ManageAlertsConfigSubscription>>?
): List<AlertSubCategoryPreference>? {
    val subCategoryOrder = listOf(
        "security",
        "processing",
        "transfers",
        "bill_payments",
        "account_balance",
        "information"
    )

    if (data == null) return null

    return subCategoryOrder.mapNotNull { key ->
        data[key]?.let { AlertSubCategoryPreference(key, it) }
    }
}


if let orderedData = viewModel.getOrderedCategoryPreferenceData(data: model.state?.categoryPreferenceData) {
    ForEach(orderedData, id: \.subCategoryId) { item in
        let subCategoryId = item.subCategoryId
        let alerts = item.alerts
        // use them directly
    }
}

