import SwiftUI
import Theme

/// A screen that displays account preferences, including errors, loading states, and account lists.
struct AccountPreferencesScreen: View {
    /// The ViewModel providing account preferences data.
    @State private var viewModel: AccountPreferencesViewModel
    /// The observable model managing the state and actions.
    @ObservedObject private var model: ObservableModel<AccountPreferencesUIState, AccountPreferencesActionState>

    /// Initializes the AccountPreferencesScreen with a ViewModel.
    /// - Parameter viewModel: The ViewModel responsible for managing account preferences.
    init(viewModel: AccountPreferencesViewModel) {
        self.viewModel = viewModel
        self.model = ObservableModel(
            statePublisher: asPublisher(viewModel.accountPreferencesUIStateWrapped),
            actionPublisher: asPublisher(viewModel.accountPreferencesActionStateWrapped)
        )
    }

    /// The main body of the AccountPreferencesScreen.
    var body: some View {
        ScrollView {
            LoadingErrorLayout(
                isLoading: model.state?.isLoading,
                hasData: model.state?.hasData,
                hasFullError: model.state?.hasUnexpectedError,
                hasInlineError: model.state?.hasError,
                inlineError: { errorInlineView() },
                fullError: { errorFullView() }
            )
            accountListView()
        }
    }
}

extension AccountPreferencesScreen {
    /// Displays an inline error view.
    /// - Returns: A type-erased view representing the inline error message.
    @ViewBuilder
    private func errorInlineView() -> AnyView {
        let stateErrorPresenter = viewModel.createErrorPresenter(error: model.state?.error)
        AnyView(
            ErrorInlineListView(
                alertType: AlertType.failure.rawValue,
                alertMessage: stateErrorPresenter.formatGlobalAlertMessage(),
                alertCode: stateErrorPresenter.formatErrorForGlobalAlertCode()
            )
        )
    }

    /// Displays a full-page error view.
    /// - Returns: A type-erased view representing the full-page error message.
    @ViewBuilder
    private func errorFullView() -> AnyView {
        let fullPagePresenter = viewModel.createProblemsFullPagePresenter(
            stateError: model.state?.error,
            resourceError: nil
        )
        AnyView(
            ErrorContentView(
                imageName: ComponentConstants.Images.alertFullPage,
                title: fullPagePresenter.formatFullPageErrorTitle(),
                subtitle: fullPagePresenter.formatErrorForPageCode(),
                message: fullPagePresenter.formatFullPageAlertMessage(),
                errorCode: fullPagePresenter.code,
                actionLabel: fullPagePresenter.formatFullPageErrorAlertCTA()
            )
        )
    }

    /// Displays a list of account groups.
    /// - Returns: A view displaying a list of account groups and their associated accounts.
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
        .padding(.horizontal, BankingTheme.dimensions.medium)
        .padding(.top, BankingTheme.spacing.noPadding)
        .padding(.bottom, BankingTheme.dimensions.extraLarge)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    /// Displays a list of accounts within an account group.
    /// - Parameter accounts: The list of accounts to display.
    /// - Returns: A view representing the account list.
    @ViewBuilder
    private func accountList(for accounts: [Account]) -> some View {
        VStack(alignment: .leading, spacing: BankingTheme.dimensions.smallMedium) {
            ForEach(accounts, id: \.self) { account in
                let presenter = viewModel.createAccountPresenter(account: account)
                AccountPreferenceCard(data: presenter.toAccountPreferenceCardData())
            }
        }
    }
}

extension AccountPreferencesScreen {
    /// A section view that includes a header and content.
    private struct AccountGroupSectionView<Content: View>: View {
        /// The header text for the section.
        let headerText: String
        /// The content to display below the header.
        let content: Content

        /// Initializes the section view with a header and content.
        /// - Parameters:
        ///   - headerText: The text for the section header.
        ///   - content: A closure that provides the content view.
        init(headerText: String, @ViewBuilder content: () -> Content) {
            self.headerText = headerText
            self.content = content()
        }

        /// The body of the section view.
        var body: some View {
            VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
                SectionHeadingView(headerText)
                    .padding(.horizontal, BankingTheme.spacing.noPadding)
                    .padding(.bottom, BankingTheme.dimensions.smallMedium)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                content
            }
            .padding(.bottom, BankingTheme.dimensions.extraLarge)
        }
    }
}
