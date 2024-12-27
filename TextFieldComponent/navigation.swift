struct AccountPreferencesDetailsScreen: View {
    @State private var isToggled: Bool = false
    private let viewModel: AccountPreferencesDetailsViewModel
    @ObservedObject private var model: ObservableModelState<AccountPreferencesDetailsResourceUIState>
    
    init(viewModel: AccountPreferencesDetailsViewModel) {
        self.viewModel = viewModel
        self.model = ObservableModelState(
            resourcePublisher: asPublisher(viewModel.resourceStateWrapped),
            statePublisher: asPublisher(viewModel.uiStateWrapped)
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            // Header Section
            AccountPreferenceHeader(
                data: AccountPreferenceHeaderData(
                    primaryText: "Account name",
                    secondaryText: "(••••0001)",
                    badgeIndicators: Array(repeating: BadgeIndicatorData(type: .passive, text: "Hidden"), count: 3)
                )
            )
            
            // Account Control Section
            createPreferenceCard(
                headerText: presenter.accountControlHeaderTitle,
                infoIconAccessibilityText: presenter.accountControlInfoIconAccessibilityText,
                infoIconDialogBodyText: presenter.accountControlInfoIconDialogBodyText,
                infoIconDialogCancelButtonText: presenter.infoIconDialogCloseButtonText,
                items: [
                    ListCellItemData(
                        actionCellId: "1",
                        actionPrimaryLabel: presenter.accountControlHideThisAccountText,
                        actionPrimaryLabelAccessibilityText: presenter.accountControlHideThisAccountText
                    )
                ],
                toggleAction: { isToggled.toggle() }
            )
            
            // Account Nickname Section
            createPreferenceCard(
                headerText: presenter.accountNicknameHeaderTitle,
                infoIconAccessibilityText: presenter.accountNicknameInfoIconAccessibilityText,
                infoIconDialogBodyText: presenter.accountNicknameInfoIconDialogBodyText,
                infoIconDialogCancelButtonText: presenter.infoIconDialogCloseButtonText
            ) {
                AccountNicknameView(
                    label: presenter.accountNicknameText,
                    buttonText: presenter.accountNicknameAddNicknameButtonText
                )
            }
            
            Spacer()
                .padding(.horizontal, BankingTheme.dimens.medium)
        }
        .padding()
    }
    
    private func createPreferenceCard(
        headerText: String,
        infoIconAccessibilityText: String,
        infoIconDialogBodyText: String,
        infoIconDialogCancelButtonText: String,
        items: [ListCellItemData] = [],
        toggleAction: (() -> Void)? = nil,
        content: (() -> AnyView)? = nil
    ) -> some View {
        AccountPreferenceCardContainerView(
            headerText: headerText,
            infoIconAccessibilityText: infoIconAccessibilityText,
            infoIconDialogBodyText: infoIconDialogBodyText,
            infoIconDialogCancelButtonText: infoIconDialogCancelButtonText
        ) {
            if let toggleAction = toggleAction {
                ForEach(items, id: \.actionCellId) { item in
                    ListCellItemToggle(
                        backgroundColor: BankingTheme.colors.illustrationGrey,
                        listCellItemData: item,
                        showDivider: false,
                        onAction: toggleAction,
                        isToggled: $isToggled
                    )
                }
            } else if let content = content {
                content()
            }
        }
    }
}

private struct AccountNicknameView: View {
    let label: String
    let buttonText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(BankingTheme.typography.body)
            Button(buttonText, action: {})
                .buttonStyle(PrimaryButtonStyle())
        }
    }
}
