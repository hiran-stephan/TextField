private var editingVisibilityBinding: Binding<Bool> {
    Binding(
        get: { isEditingVisibility },
        set: { newValue in
            viewModel.updateVisibilityEditingStatus(status: newValue)
            accountShowAlert = true
        }
    )
}
isToggled: editingVisibilityBinding



private var dialogTitle: String {
    isEditingVisibility ? presenter.accountDisplayShowDialogTitleText : presenter.accountDisplayDialogTitleText
}

private var dialogMessage: String {
    isEditingVisibility ? presenter.accountDisplayShowDialogBodyText : presenter.accountDisplayDialogBodyText
}

titleProvider: { dialogTitle },
messageProvider: { dialogMessage }



private func alertActions(forEditingVisibility isEditing: Bool) -> [AlertAction] {
    if isEditing {
        return [
            AlertAction(
                title: presenter.accountControlDisplayShowBackButtonText,
                style: .default,
                handler: { viewModel.updateVisibilityEditingStatus(status: true) }
            ),
            AlertAction(
                title: presenter.accountControlDisplayShowContinueButtonText,
                style: .default,
                handler: {}
            )
        ]
    } else {
        return [
            AlertAction(
                title: presenter.accountControlDisplayBackButtonText,
                style: .default,
                handler: { viewModel.updateVisibilityEditingStatus(status: false) }
            ),
            AlertAction(
                title: presenter.accountControlDisplayContinueButtonText,
                style: .default,
                handler: {}
            )
        ]
    }
}


actionsProvider: { alertActions(forEditingVisibility: isEditingVisibility) }


private func createAccountControlItems() -> [ListCellItemData] {
    return [
        ListCellItemData(
            actionCellId: "1",
            actionPrimaryLabel: presenter.accountControlHideThisAccountText,
            actionPrimaryLabelAccessibilityText: presenter.accountControlHideThisAccountText
        )
    ]
}

private func createAccountControlList(items: [ListCellItemData]) -> some View {
    ListCardContainer(style: BorderlessCardStyle()) {
        VStack(spacing: BankingTheme.spacing.noPadding) {
            ForEach(items, id: \.actionCellId) { item in
                ListCellItemToggle(
                    backgroundColor: BankingTheme.colors.illustrationGrey,
                    pressedBackgroundColor: BankingTheme.colors.illustrationGrey,
                    listCellItemData: item,
                    showDivider: false,
                    isToggled: editingVisibilityBinding
                )
            }
        }
    }
}

private func accountControlSection() -> some View {
    let items = createAccountControlItems()
    return createPreferenceCard(
        headerText: presenter.accountControlHeaderTitle,
        infoIconAccessibilityText: presenter.accountControlInfoIconAccessibilityText,
        infoIconDialogBodyText: presenter.accountControlInfoIconDialogBodyText,
        infoIconDialogCloseButtonText: presenter.infoIconDialogCloseButtonText
    ) {
        createAccountControlList(items: items)
    }
    .presentAlert(
        isPresented: $accountShowAlert,
        titleProvider: { dialogTitle },
        messageProvider: { dialogMessage },
        actionsProvider: { alertActions(forEditingVisibility: isEditingVisibility) }
    )
}

