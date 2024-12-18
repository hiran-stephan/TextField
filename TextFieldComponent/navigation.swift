
let header = accountGroupPresenter.label

AccountGroupSectionView(headerText: header) {
    VStack {
        ForEach(accountGroup.accounts, id: \.self) { account in
            let accountPresenter = viewModel.createAccountPresenter(account: account)
            let cardData = accountPresenter.toAccountPreferenceCardData()
            return AccountPreferenceCard(data: cardData) // Explicit return
        }
    }
}
