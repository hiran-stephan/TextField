extension AccountPreferencesDetailsScreen {

    /// A form view for managing account nicknames.
    private struct AccountNicknameFormView: View {
        // MARK: - Properties

        /// The label to display as the account nickname.
        let label: String

        /// The text to display on the button.
        @State var buttonText: String

        /// The inline message text to display under the field.
        let inlineMessageText: String

        /// The primary button's title.
        let primaryButtonText: String

        /// The secondary button's title.
        let secondaryButtonText: String

        /// The action to perform when the button is tapped.
        let onButtonTap: () -> Void

        // MARK: - Initializer

        init(
            label: String,
            buttonText: String,
            inlineMessageText: String,
            primaryButtonText: String,
            secondaryButtonText: String,
            onButtonTap: @escaping () -> Void
        ) {
            self.label = label
            self._buttonText = State(initialValue: buttonText)
            self.inlineMessageText = inlineMessageText
            self.primaryButtonText = primaryButtonText
            self.secondaryButtonText = secondaryButtonText
            self.onButtonTap = onButtonTap
        }

        // MARK: - Body

        var body: some View {
            VStack(alignment: .leading, spacing: BankingTheme.dimensions.medium) {
                // TextField with trailing icon
                HStack(spacing: BankingTheme.spacing.noPadding) {
                    TextFieldGeneral(
                        text: $buttonText,
                        label: label,
                        trailingIcon: BankingTheme.icons.functional.close.rawValue,
                        trailingIconForegroundColor: BankingTheme.colors.textPrimary,
                        isError: false,
                        onTrailingIconClicked: onButtonTap
                    )
                    .padding(.horizontal, BankingTheme.dimensions.medium)
                }

                // Inline message
                Text(inlineMessageText)
                    .typography(BankingTheme.typography.bodySmall)
                    .foregroundColor(BankingTheme.colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.top, BankingTheme.dimensions.small)
                    .padding(.horizontal, BankingTheme.dimensions.mediumLarge)

                // Primary and Secondary Buttons
                VStack(alignment: .leading, spacing: BankingTheme.dimensions.medium) {
                    PrimaryButton(
                        content: {
                            Text(primaryButtonText)
                        },
                        buttonPaddingHorizontal: ButtonPaddingHorizontal(
                            leadingLength: 0,
                            trailingLength: 0
                        )
                    ) {
                        // Primary button action
                        onButtonTap()
                    }

                    SecondaryButton(
                        content: {
                            Text(secondaryButtonText)
                        },
                        buttonPaddingHorizontal: ButtonPaddingHorizontal(
                            leadingLength: 0,
                            trailingLength: 0
                        )
                    ) {
                        // Secondary button action
                        onButtonTap()
                    }
                }
                .padding(.top, BankingTheme.dimensions.extraLarge)
            }
            .padding(.horizontal, BankingTheme.dimensions.microSmall)
        }
    }
}
