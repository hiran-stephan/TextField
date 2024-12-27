createPreferenceCard(
    headerText: presenter.accountControlHeaderTitle,
    infoIconAccessibilityText: presenter.accountControlInfoIconAccessibilityText,
    infoIconDialogBodyText: presenter.accountControlInfoIconDialogBodyText,
    infoIconDialogCancelButtonText: presenter.infoIconDialogCloseButtonText
) {
    ForEach(accountControlItems, id: \.actionCellId) { item in
        ListCellItemToggle(
            backgroundColor: BankingTheme.colors.illustrationGrey,
            listCellItemData: item,
            showDivider: false,
            onAction: {
                // Handle toggle action here
                print("Toggle action for \(item.actionPrimaryLabel)")
            },
            isToggled: $isToggled
        )
    }
}

let accountControlItems: [ListCellItemData] = [
    ListCellItemData(
        actionCellId: "1",
        actionPrimaryLabel: presenter.accountControlHideThisAccountText,
        actionPrimaryLabelAccessibilityText: presenter.accountControlHideThisAccountText
    )
]

createPreferenceCard(
    headerText: presenter.accountControlHeaderTitle,
    infoIconAccessibilityText: presenter.accountControlInfoIconAccessibilityText,
    infoIconDialogBodyText: presenter.accountControlInfoIconDialogBodyText,
    infoIconDialogCancelButtonText: presenter.infoIconDialogCloseButtonText
) {
    ForEach(accountControlItems, id: \.actionCellId) { item in
        ListCellItemToggle(
            backgroundColor: BankingTheme.colors.illustrationGrey,
            listCellItemData: item,
            showDivider: false,
            onAction: {
                // Handle toggle action for each item
                print("Toggle action for \(item.actionPrimaryLabel)")
            },
            isToggled: $isToggled
        )
    }
}
