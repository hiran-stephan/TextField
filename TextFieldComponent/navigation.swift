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
    private func accountControlSection() -> some View {
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
    private func accountNicknameSection() -> some View {
        createPreferenceCard(
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
}
