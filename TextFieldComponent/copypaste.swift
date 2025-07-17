viewModel.getCategoryPreferenceData(uiState.categoryPreferenceData)?.forEach { preference ->
    val subCategoryId = preference.subCategoryId
    val alertConfigSubscriptions = preference.alerts

    val subCategoryHeadingPresenter = remember(subCategoryId) {
        viewModel.createManageAlertSubCategoryHeadingPresenter(
            manageAlertsSubCategoriesResourceState = resourceState,
            subCategoryId = subCategoryId,
        )
    }

    SectionHeader(
        modifier = Modifier.padding(bottom = BankingTheme.dimens.small),
        infoText = subCategoryHeadingPresenter.alertSectionHeading,
        infoTextStyle = BankingTheme.typography.headingSmall,
        infoTextColor = BankingTheme.colors.onBackground,
        icon = if (subCategoryHeadingPresenter.showInfoIcon)
            BankingTheme.Images.Functional.quickTip else null,
        iconAccessibility = subCategoryHeadingPresenter.infoDialogAccessibilityText,
        infoIconClicked = { viewModel.onInfoIconClicked() }
    )

    ListCardContainer(
        modifier = Modifier.padding(bottom = BankingTheme.dimens.medium),
        hasBorder = false,
        isRoundedShape = true,
        backgroundColor = BankingTheme.colors.illustrationGrey,
        verticalPadding = BankingTheme.dimens.microSmall
    ) {
        Column(modifier = Modifier.fillMaxWidth()) {
            // render alert items...
        }
    }
}
