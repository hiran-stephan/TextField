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

private struct AccountNicknameView: View {
    let label: String
    let buttonText: String
    let onButtonTap: () -> Void

    init(label: String, buttonText: String, onButtonTap: @escaping () -> Void) {
        self.label = label
        self.buttonText = buttonText
        self.onButtonTap = onButtonTap
    }

    var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.dimens.mediumLarge) {
            VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
                Text(label)
                    .typography(BankingTheme.typography.bodySmall)
                    .foregroundColor(BankingTheme.colors.textSecondary)
            }

            HStack(alignment: .center, spacing: BankingTheme.dimens.small) {
                TextLinkButton(
                    title: buttonText,
                    type: .default,
                    removePadding: true,
                    onButtonTap: onButtonTap
                )
            }
            .padding(.vertical, BankingTheme.dimens.small)

            Spacer()
        }
        .padding(BankingTheme.dimens.mediumLarge)
        .background(BankingTheme.colors.illustrationGrey)
        .cornerRadius(8) // Optionally, add corner radius for better styling
    }
}
