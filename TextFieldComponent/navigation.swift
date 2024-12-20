@ViewBuilder
private func contentView() -> some View {
    guard let accountGroups = model.state?.accountsSummary?.accountGroups else {
        return EmptyView()
    }
    
    VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
        ForEach(accountGroups, id: \.self) { accountGroup in
            let groupPresenter = viewModel.createAccountGroupPresenter(accountGroup: accountGroup)
            let groupAccounts = groupPresenter.sortedAccountsList()
            GroupSectionContainerView(groupPresenter: groupPresenter) {
                ForEach(groupAccounts, id: \.self) { account in
                    makeAccountRow(account)
                }
            }
        }
        
        makeLastOnlineView()
        
        // Apply padding to the entire VStack
        Spacer() // Add spacing if needed
    }
    .padding(.horizontal, BankingTheme.dimens.medium)
    .padding(.bottom, BankingTheme.dimens.medium)
    
    VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
        // Other content
        makeBottomSection()
    }
    
}

private var accountGroups: [AccountGroup] {
    model.state?.accountsSummary?.accountGroups ?? []
}


private func createGroupPresenter(for accountGroup: AccountGroup) -> GroupPresenterType {
    viewModel.createAccountGroupPresenter(accountGroup: accountGroup)
}
