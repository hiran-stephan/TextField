@ViewBuilder
private func accountList(for accounts: [Account]) -> some View {
    VStack(alignment: .leading, spacing: BankingTheme.spacing.small) { // Adjust spacing here
        ForEach(accounts, id: \.self) { account in
            let presenter = viewModel.createAccountPresenter(account: account)
            AccountPreferenceCard(data: presenter.toAccountPreferenceCardData())
        }
    }
}
