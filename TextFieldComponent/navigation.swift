import SwiftUI

struct AccountPreferencesScreen: View {
    @State private var viewModel: AccountPreferencesViewModel
    @ObservedObject private var model: ObservableModel<AccountPreferencesUIState, AccountPreferencesActionState>
    
    init(viewModel: AccountPreferencesViewModel) {
        self.viewModel = viewModel
        self.model = ObservableModel(
            statePublisher: asPublisher(viewModel.accountPreferencesUIStateWrapped),
            actionPublisher: asPublisher(viewModel.accountPreferencesActionStateWrapped)
        )
    }

    var body: some View {
        ScrollView {
            LoadingErrorLayout(
                isLoading: model.state?.isLoading ?? false,
                hasData: model.state?.hasData ?? false,
                hasFullError: model.state?.hasUnexpectedError ?? false,
                hasInlineError: model.state?.hasError ?? false,
                inlineError: errorInlineView(),
                fullError: errorFullView()
            )
            .onAppear { viewModel.fetchResources() }

            accountListView()
        }
        .padding(.horizontal, BankingTheme.dimensions.medium)
        .padding(.top, BankingTheme.spacing.noPadding)
        .padding(.bottom, BankingTheme.dimensions.extraLarge)
    }
}

extension AccountPreferencesScreen {
    @ViewBuilder
    private func errorInlineView() -> some View {
        ErrorInlineListView(
            alertType: AlertType.failure.rawValue,
            alertMessage: viewModel.createErrorPresenter(error: model.state?.error).formatErrorForGlobalAlertMessage(),
            alertCode: viewModel.createErrorPresenter(error: model.state?.error).formatErrorForGlobalAlertCode()
        )
    }

    @ViewBuilder
    private func errorFullView() -> some View {
        let fullPagePresenter = viewModel.createProblemsFullPagePresenter(stateError: model.state?.error, resourceError: nil)

        ErrorContentView(
            imageName: ComponentConstants.Images.alertFullPage,
            title: fullPagePresenter.formatFullPageErrorTitle(),
            subtitle: fullPagePresenter.formatErrorForPageCode(),
            message: fullPagePresenter.formatFullPageAlertMessage(),
            errorCode: fullPagePresenter.code,
            actionLabel: fullPagePresenter.formatFullPageErrorCTA()
        )
    }

    @ViewBuilder
    private func accountListView() -> some View {
        let accountGroups = model.state?.accountGroups ?? []
        
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            ForEach(accountGroups, id: \.self) { accountGroup in
                let groupPresenter = viewModel.createAccountGroupPresenter(accountGroup: accountGroup)
                
                AccountGroupSectionView(headerText: groupPresenter.label) {
                    accountList(for: accountGroup.accounts)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    @ViewBuilder
    private func accountList(for accounts: [Account]) -> some View {
        ForEach(accounts, id: \.self) { account in
            let presenter = viewModel.createAccountPresenter(account: account)
            AccountPreferenceCard(data: presenter.toAccountPreferenceCardData())
        }
    }
}
