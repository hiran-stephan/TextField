/// A SwiftUI view displaying a section of text with a primary and secondary label.
/// The section dynamically adjusts its size and emits its frame via a preference key.
struct AccountTextSection: View {
    /// The primary text to be displayed.
    let primaryText: String
    /// The secondary text to be displayed.
    let secondaryText: String

    /// The layout of the view, consisting of primary and secondary text stacked vertically.
    var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            // Primary body text
            Text(primaryText)
                .typography(BankingTheme.typography.body)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .topLeading)

            // Secondary body text
            Text(secondaryText)
                .typography(BankingTheme.typography.bodySmall)
                .foregroundColor(BankingTheme.colors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            GeometryReader { geometry in
                Color.clear
                    .preference(
                        key: ViewFramePreferenceKey.self,
                        value: geometry.frame(in: .global)
                    )
            }
        )
    }
}
