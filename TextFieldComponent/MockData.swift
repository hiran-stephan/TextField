fun updatePreferenceDetailItem(id: String?, deliveryMethod: String, selected: Boolean) {
    _manageAlertsAlertSettingsUiState.update { state ->
        val existingList = state.preferenceDetailList

        val updatedList = when {
            // 1. If item exists and selected = true → update it
            existingList.any { it.deliveryMethod == deliveryMethod } && selected -> {
                existingList.map {
                    if (it.deliveryMethod == deliveryMethod) it.copy(selected = true, id = id) else it
                }
            }

            // 2. If item exists and selected = false → remove it
            existingList.any { it.deliveryMethod == deliveryMethod } && !selected -> {
                existingList.filterNot { it.deliveryMethod == deliveryMethod }
            }

            // 3. If item doesn't exist and selected = true → add it
            selected -> {
                existingList + PreferenceDetailData(
                    id = id,
                    deliveryMethod = deliveryMethod,
                    selected = true
                )
            }

            // 4. If item doesn't exist and selected = false → do nothing
            else -> existingList
        }

        state.copy(preferenceDetailList = updatedList)
    }
}
