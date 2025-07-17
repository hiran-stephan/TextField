private val subCategoryOrder = listOf(
    "security",
    "processing",
    "transfers",
    "bill_payments",
    "account_balance",
    "information"
)

fun getOrderedCategoryPreferenceData(): List<Pair<String, List<ManageAlertsConfigSubscription>>> {
    return subCategoryOrder.mapNotNull { key ->
        categoryPreferenceData?.get(key)?.let { key to it }
    }
}

let categoryPreferenceDataArr = viewModel.getOrderedCategoryPreferenceData()

