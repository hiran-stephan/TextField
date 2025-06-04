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
