import SwiftUI

// MARK: - Main View
struct AccountPreferencesScreen: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            accountListView()
        }
        .padding(.horizontal, Constants.Padding2Xs)
        .padding(.top, Constants.Padding3Xs)
        .padding(.bottom, Constants.PaddingLg)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

// MARK: - Subviews
extension AccountPreferencesScreen {
    @ViewBuilder
    private func accountListView() -> some View {
        let accountGroups: [AccountGroup] = model.state?.accountGroups ?? []

        ForEach(accountGroups, id: \.self) { accountGroup in
            let accountGroupPresenter = viewModel.createAccountGroupPresenter(accountGroup: accountGroup)
            
            AccountGroupSectionView(headerText: accountGroupPresenter.label) {
                accountList(for: accountGroup.accounts)
            }
        }
    }
    
    @ViewBuilder
    private func accountList(for accounts: [Account]) -> some View {
        ForEach(accounts, id: \.self) { account in
            let accountPresenter = viewModel.createAccountPresenter(account: account)
            let cardData = accountPresenter.toAccountPreferenceCardData()
            AccountPreferenceCard(data: cardData)
        }
    }
}

// MARK: - AccountGroupSectionView
struct AccountGroupSectionView<Content: View>: View {
    let headerText: String
    let content: Content

    init(headerText: String, @ViewBuilder content: () -> Content) {
        self.headerText = headerText
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeadingView(headerText)
            content
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

// MARK: - Constants
struct Constants {
    static let Padding3Xs: CGFloat = 12
    static let PaddingLg: CGFloat = 32
    static let Padding2Xs: CGFloat = 16
}
