extension AccountPreferencesDetailsScreen {
    /// A section view that includes a header and an interactive button.
    private struct AccountNicknameView: View {
        // MARK: - Properties
        
        /// The header text for the section.
        let label: String
        
        /// The button text displayed below the header.
        let buttonText: String
        
        /// A closure to handle the button tap action.
        let onButtonTap: () -> Void
        
        // MARK: - Initialization
        init(label: String, buttonText: String, onButtonTap: @escaping () -> Void) {
            self.label = label
            self.buttonText = buttonText
            self.onButtonTap = onButtonTap
        }
        
        // MARK: - Body
        var body: some View {
            VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
                // Header Label
                Text(label)
                    .typography(BankingTheme.typography.bodySmall)
                    .foregroundColor(BankingTheme.colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                // Interactive Button
                HStack(alignment: .center, spacing: BankingTheme.dimens.small) {
                    TextLinkButton(
                        title: buttonText,
                        type: .default,
                        removePadding: true
                    ) {
                        onButtonTap()
                    }
                }
                .padding(.vertical, BankingTheme.dimens.small)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, BankingTheme.dimens.mediumLarge)
            .background(BankingTheme.colors.illustrationGrey)
            .cornerRadius(BankingTheme.dimens.smallMedium)
        }
    }
}
