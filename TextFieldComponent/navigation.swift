/// A view that displays account preferences details.
struct AccountPreferencesDetailsScreen: View {
    /// The view model for managing account preferences details.
    @State private var viewModel: AccountPreferencesDetailsViewModel
    
    /// An observed object to handle state updates for resource and UI states.
    @ObservedObject private var model: ObservableModelState<AccountPreferencesDetailsResourceUIState>
    
    /// Tracks the toggle state for account control actions.
    @State private var isToggled: Bool = false

    /// Initializes the screen with a given view model.
    /// - Parameter viewModel: The view model to manage account preferences data.
    init(viewModel: AccountPreferencesDetailsViewModel) {
        self.viewModel = viewModel
        self.model = ObservableModelState(
            resourcePublisher: asPublisher(viewModel.resourceStateWrapped),
            statePublisher: asPublisher(viewModel.uiStateWrapped)
        )
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: BankingTheme.spacing.noPadding) {
            headerSection()
            accountControlSection()
            accountNicknameSection()
            Spacer()
                .padding(.horizontal, BankingTheme.dimens.medium)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
    
    // MARK: - Header Section

    /// Displays the account preferences header.
    /// - Returns: A view representing the header section.
    private func headerSection() -> some View {
        AccountPreferenceHeader(
            data: AccountPreferenceHeaderData(
                primaryText: "Account name",
                secondaryText: "(••••0001)",
                badgeIndicators: Array(
                    repeating: BadgeIndicatorData(type: .passive, text: "Hidden"),
                    count: 3
                )
            )
        )
    }
    
    // MARK: - Account Control Section

    /// Displays the account control actions, such as toggling account visibility.
    /// - Returns: A view representing the account control section.
    private func accountControlSection() -> some View {
        let presenter = viewModel.createScreenPresenter()
        let accountControlItems: [ListCellItemData] = [
            ListCellItemData(
                actionCellId: "1",
                actionPrimaryLabel: presenter.accountControlHideThisAccountText,
                actionPrimaryLabelAccessibilityText: presenter.accountControlHideThisAccountText
            )
        ]
        
        return createPreferenceCard(
            headerText: presenter.accountControlHeaderTitle,
            infoIconAccessibilityText: presenter.accountControlInfoIconAccessibilityText,
            infoIconDialogBodyText: presenter.accountControlInfoIconDialogBodyText,
            infoIconDialogCancelButtonText: presenter.infoIconDialogCloseButtonText
        ) {
            ListCardContainer(
                hasBorder: false,
                isRoundedShape: true,
                backgroundColor: BankingTheme.colors.illustrationGrey,
                horizontalPadding: BankingTheme.dimens.medium
            ) {
                ForEach(accountControlItems, id: \.actionCellId) { actionItem in
                    ListCellItemToggle(
                        backgroundColor: BankingTheme.colors.illustrationGrey,
                        listCellItemData: actionItem,
                        showDivider: false,
                        onAction: {
                            // Toggle Action
                        },
                        isToggled: $isToggled
                    )
                }
            }
        }
    }
    
    // MARK: - Account Nickname Section

    /// Displays the account nickname section, including a button for nickname updates.
    /// - Returns: A view representing the account nickname section.
    private func accountNicknameSection() -> some View {
        let presenter = viewModel.createScreenPresenter()
        return createPreferenceCard(
            headerText: presenter.accountNicknameHeaderTitle,
            infoIconAccessibilityText: presenter.accountNicknameInfoIconAccessibilityText,
            infoIconDialogBodyText: presenter.accountNicknameInfoIconDialogBodyText,
            infoIconDialogCancelButtonText: presenter.infoIconDialogCloseButtonText
        ) {
            AccountNicknameView(
                label: presenter.accountNicknameText,
                buttonText: presenter.accountNicknameAddNicknameButtonText
            ) {
                // Perform action when the button is tapped
                print("Nickname button tapped")
            }
        }
    }
    
    // MARK: - Utility

    /// Creates a preference card container with the specified content.
    /// - Parameters:
    ///   - headerText: The text to display in the card's header.
    ///   - infoIconAccessibilityText: Accessibility text for the info icon.
    ///   - infoIconDialogBodyText: Body text for the info dialog.
    ///   - infoIconDialogCancelButtonText: Text for the cancel button in the dialog.
    ///   - content: A closure providing the card's content.
    /// - Returns: A view representing the preference card container.
    private func createPreferenceCard<Content: View>(
        headerText: String,
        infoIconAccessibilityText: String,
        infoIconDialogBodyText: String,
        infoIconDialogCancelButtonText: String,
        content: @escaping () -> Content
    ) -> some View {
        AccountPreferenceCardContainerView(
            headerText: headerText,
            infoIconAccessibilityText: infoIconAccessibilityText,
            infoIconDialogBodyText: infoIconDialogBodyText,
            infoIconDialogCancelButtonText: infoIconDialogCancelButtonText
        ) {
            content()
        }
    }
}

// MARK: - Account Nickname View

extension AccountPreferencesDetailsScreen {
    /// A view that displays the account nickname with a button for updates.
    private struct AccountNicknameView: View {
        /// The label to display as the account nickname.
        let label: String
        
        /// The text to display on the button.
        let buttonText: String
        
        /// The action to perform when the button is tapped.
        let onButtonTap: () -> Void
        
        var body: some View {
            VStack(alignment: .leading, spacing: BankingTheme.dimens.mediumLarge) {
                Text(label)
                    .typography(BankingTheme.typography.bodySmall)
                    .foregroundColor(BankingTheme.colors.textSecondary)
                
                Button(buttonText, action: onButtonTap)
                    .buttonStyle(DefaultButtonStyle())
            }
            .padding(BankingTheme.dimens.medium)
            .background(BankingTheme.colors.illustrationGrey)
            .cornerRadius(8)
        }
    }
}
