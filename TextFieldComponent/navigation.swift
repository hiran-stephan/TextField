extension AccountPreferencesDetailsScreen {

    /// A form view for managing account nicknames.
    private struct AccountNicknameFormView: View {
        // MARK: - Properties

        let label: String
        @State var buttonText: String
        let inlineMessageText: String
        let primaryButtonText: String
        let secondaryButtonText: String
        let onTextFieldCloseButtonTap: () -> Void
        let onPrimaryButtonTap: () -> Void
        let onSecondaryButtonTap: () -> Void

        // MARK: - Body

        var body: some View {
            VStack(spacing: BankingTheme.dimensions.medium) {
                formSection()
                buttonSection()
            }
            .padding(.horizontal, BankingTheme.dimensions.microSmall)
        }

        // MARK: - Methods

        /// Builds the form section with the text field and inline message.
        private func formSection() -> some View {
            VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
                // TextField with trailing icon
                TextFieldGeneral(
                    text: $buttonText,
                    label: label,
                    trailingIcon: BankingTheme.icons.functional.close.rawValue,
                    trailingIconForegroundColor: BankingTheme.colors.textPrimary,
                    isError: false,
                    onTrailingIconClicked: onTextFieldCloseButtonTap
                )
                .padding(.horizontal, BankingTheme.dimensions.medium)

                // Inline message
                Text(inlineMessageText)
                    .typography(BankingTheme.typography.bodySmall)
                    .foregroundColor(BankingTheme.colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top, BankingTheme.dimensions.small)
                    .padding(.horizontal, BankingTheme.dimensions.mediumLarge)
                    .background(BankingTheme.colors.illustrationGrey)
                    .cornerRadius(BankingTheme.dimensions.smallMedium)
            }
        }

        /// Builds the button section with primary and secondary buttons.
        private func buttonSection() -> some View {
            VStack(alignment: .leading, spacing: BankingTheme.dimensions.medium) {
                PrimaryButton(
                    content: {
                        Text(primaryButtonText)
                    },
                    buttonPaddingHorizontal: ButtonPaddingHorizontal(
                        leadingLength: 0,
                        trailingLength: 0
                    ),
                    action: onPrimaryButtonTap
                )

                SecondaryButton(
                    content: {
                        Text(secondaryButtonText)
                    },
                    buttonPaddingHorizontal: ButtonPaddingHorizontal(
                        leadingLength: 0,
                        trailingLength: 0
                    ),
                    action: onSecondaryButtonTap
                )
            }
            .padding(.top, BankingTheme.dimensions.extraLarge)
        }
    }
}
