extension AccountPreferencesDetailsScreen {
    /// A view that displays an account nickname with a button.
    ///
    /// This view is used to show a label (account nickname) and a button for further actions.
    /// The button can trigger a specific function passed as a closure.
    private struct AccountNicknameView: View {
        /// The label to display as the account nickname.
        let label: String

        /// The text to display on the button.
        let buttonText: String

        /// The action to perform when the button is tapped.
        let onButtonTap: () -> Void

        /// Initializes the `AccountNicknameView`.
        ///
        /// - Parameters:
        ///   - label: The label to display as the account nickname.
        ///   - buttonText: The text to display on the button.
        ///   - onButtonTap: The closure to execute when the button is tapped.
        init(label: String, buttonText: String, onButtonTap: @escaping () -> Void) {
            self.label = label
            self.buttonText = buttonText
            self.onButtonTap = onButtonTap
        }

        var body: some View {
            HStack(alignment: .top, spacing: BankingTheme.dimensions.mediumLarge) {
                VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
                    Text(label)
                        .typography(BankingTheme.typography.bodySmall)
                        .foregroundColor(BankingTheme.colors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }

                HStack(alignment: .center, spacing: BankingTheme.dimensions.small) {
                    TextLinkButton(
                        title: buttonText,
                        type: .default,
                        removePadding: true
                    ) {
                        onButtonTap()
                    }
                }
                .padding(.vertical, BankingTheme.dimensions.small)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, BankingTheme.dimensions.mediumLarge)
            .padding(.horizontal, BankingTheme.dimensions.mediumLarge)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(BankingTheme.colors.illustrationGrey)
            .cornerRadius(BankingTheme.dimensions.smallMedium)
        }
    }
}
