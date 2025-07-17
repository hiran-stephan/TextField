private val subCategoryOrder = listOf(
    "security",
    "processing",
    "transfers",
    "bill_payments",
    "account_balance",
    "information"
)

fun getOrderedCategoryPreferenceData(
    data: Map<String, List<ManageAlertsConfigSubscription>>?
): List<Pair<String, List<ManageAlertsConfigSubscription>>> {
    if (data == null) return emptyList()

    return subCategoryOrder.mapNotNull { key ->
        data[key]?.let { key to it }
    }
}


let orderedData = viewModel.getOrderedCategoryPreferenceData(data: uiState.categoryPreferenceData)

if let categoryPreferenceData = viewModel.getOrderedCategoryPreferenceData(data: model.state?.categoryPreferenceData) {
    let categoryPreferenceDataArr = categoryPreferenceData.map { (pair: KotlinPair) in
        (pair.first as? String ?? "", pair.second as? [ManageAlertsConfigSubscription] ?? [])
    }
    
    ForEach(categoryPreferenceDataArr, id: \.0) { subCategoryId, alerts in
        // ... your existing UI rendering logic
    }
}
