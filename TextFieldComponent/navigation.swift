struct ChangeUserIdScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            formContent
                .background(BankingTheme.colors.illustrationGrey)
                .cornerRadius(BankingTheme.dimens.smallMedium)
                .padding(.horizontal, BankingTheme.dimens.mediumLarge)
                .padding(.top, BankingTheme.dimens.extraLarge)

            actionBar
                .padding(.horizontal, BankingTheme.dimens.mediumLarge)
                .padding(.top, BankingTheme.dimens.medium)
                .padding(.bottom, BankingTheme.dimens.extraLarge)
        }
    }

    private var formContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            currentUserIdSection
            createDivider()
            newUserIdSection
            validationSection
            confirmUserIdSection
        }
        .padding(.vertical, BankingTheme.dimens.medium)
        .padding(.horizontal, BankingTheme.dimens.mediumLarge)
    }

    private var currentUserIdSection: some View {
        VStack(alignment: .leading, spacing: BankingTheme.dimens.smallMedium) {
            TextFieldView(
                text: $oldUserIdText,
                title: changeUserIdPresenter.currentUserIdLabel
            )
        }
        .padding(.bottom, BankingTheme.dimens.medium)
    }

    private var newUserIdSection: some View {
        VStack(alignment: .leading, spacing: BankingTheme.dimens.smallMedium) {
            TextFieldView(
                text: $newUserIdText,
                title: changeUserIdPresenter.newUserIdLabel
            )
            .onChange(of: newUserIdText) { newValue in
                viewModel.updateNewUsername(username: newValue)
            }
        }
        .padding(.bottom, BankingTheme.dimens.medium)
    }

    private var validationSection: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            StandardCheckView(checks: changeUserIdValidationPresenter.toCriteriaCheckModels())
        }
        .padding(.bottom, BankingTheme.dimens.medium)
    }

    private var confirmUserIdSection: some View {
        VStack(alignment: .leading, spacing: BankingTheme.dimens.smallMedium) {
            TextFieldView(
                text: $reEnterUserIdText,
                title: changeUserIdPresenter.confirmNewUserIdLabel
            )
        }
    }

    private var actionBar: some View {
        buildActionBar()
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}
