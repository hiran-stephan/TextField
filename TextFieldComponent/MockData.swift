@ViewBuilder
private func buildCardsView() -> some View {
    let manageAlertsCategoriesPresenter = viewModel.createManageAlertsCategoriesPresenter()
    
    ForEach(manageAlertsCategoriesPresenter.manageAlertsCategoriesList, id: \.heading) { category in
        ManageAlertCardView(
            label: category.heading,
            secondaryLabel: category.subHeading,
            tertiaryLabel: category.activeSubscriptionsDetails,
            trailingView: ManageAlertCardView.TrailingView
        ) {
            viewModel.navigateToSubCategory(category.heading)
        }
        .disclosure(
            ComponentImage(
                BankingTheme.icons.functional.chevronRight
            )
        )
    }
}

private fun getHeadingAndSubHeading(category: String): Pair<String, String> {
    return when (mapCategoryToKey(category)) {
        SERVICING_HEADING -> Pair(
            displayContent(SERVICING_HEADING),
            displayContent(SERVICING_SUBHEADING)
        )
        TRANSACTIONS_HEADING -> Pair(
            displayContent(TRANSACTIONS_HEADING),
            displayContent(TRANSACTIONS_SUBHEADING)
        )
        REMINDERS_HEADING -> Pair(
            displayContent(REMINDERS_HEADING),
            displayContent(REMINDERS_SUBHEADING)
        )
        else -> Pair("", "")
    }
}

private fun mapCategoryToKey(category: String): String {
    return when (category) {
        "Servicing" -> SERVICING_HEADING
        "Transactions" -> TRANSACTIONS_HEADING
        "Reminders" -> REMINDERS_HEADING
        else -> category // fallback
    }
}
