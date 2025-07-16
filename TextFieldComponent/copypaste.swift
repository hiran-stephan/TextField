val desiredCategoryOrder = listOf("servicing", "payments_and_transfers", "reminders")

val manageAlertsCategoriesList: List<ManageAlertsCategoryData>
    get() = desiredCategoryOrder.mapNotNull { categoryId ->
        val alerts = alertsData?.get(categoryId)
        if (alerts != null) {
            val activeSubscriptionsCount = alerts.firstOrNull()?.activeSubscriptions ?: 0
            val totalSubscriptionsCount = alerts.firstOrNull()?.totalSubscriptions ?: 0

            ManageAlertsCategoryData(
                categoryId = categoryId,
                heading = displayContent("${categoryId}.heading".lowercase()),
                subHeading = displayContent("${categoryId}.subheading".lowercase()),
                activeSubscriptionsDetails =
                    displayContent(
                        key = CATEGORY_COUNT_X_OF_Y_TURNED_ON_TEXT,
                        forAccessibility = true
                    ).replace("{x}", activeSubscriptionsCount.toString())
                     .replace("{y}", totalSubscriptionsCount.toString())
            )
        } else null
    }
