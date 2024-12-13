/// A SwiftUI view that represents a card displaying account preferences, including primary text, secondary text, and optional badge indicators.
struct AccountPreferenceCard: View {
    // Data source for configuring the card content
    let data: AccountPreferenceCardData
    
    // Tracks the width of the primary text container
    @State private var bodyTextWidth: CGFloat = 0
    
    /// Initializes the account preference card with provided data.
    /// - Parameter data: The data used to populate the card's content.
    init(data: AccountPreferenceCardData) {
        self.data = data
    }
    
    /// The main layout of the account preference card.
    var body: some View {
        HStack(alignment: .center, spacing: BankingTheme.dimens.smallMedium) {
            VStack(alignment: .leading, spacing: BankingTheme.dimens.smallMedium) {
                // Displays the primary and secondary text
                AccountTextSection(
                    primaryText: data.primaryText,
                    secondaryText: data.secondaryText
                )
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .preference(
                                key: ViewFramePreferenceKey.self,
                                value: geometry.frame(in: .global)
                            )
                    }
                )
                .onPreferenceChange(ViewFramePreferenceKey.self) { frame in
                    bodyTextWidth = frame.width
                }
                
                // Displays badge indicators if available
                if !data.badgeIndicators.isEmpty {
                    BadgeIndicatorListView(
                        badges: data.badgeIndicators,
                        containerWidth: bodyTextWidth
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Displays a chevron icon on the right
            ListCellIconView(imageName: ComponentConstants.Images.chevron)
        }
        .padding(BankingTheme.dimens.medium)
        .background(BankingTheme.colors.surface)
        .cornerRadius(BankingTheme.dimens.smallMedium)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// A SwiftUI view displaying primary and secondary text with a vertical layout.
struct AccountTextSection: View {
    let primaryText: String
    let secondaryText: String
    
    /// The layout of primary and secondary text.
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
    }
}
