struct AccountPreferenceCard: View {
    /// Data source for configuring the card content
    private let data: AccountPreferenceCardData

    /// Tracks the width of the primary text container
    @State private var containerWidth: CGFloat = 0
    
    /// Action handler for the card tap
    let onTap: () -> Void

    /// Initializes the account preference card with provided data.
    /// - Parameter data: The data used to populate the card's content.
    init(data: AccountPreferenceCardData, onTap: @escaping () -> Void) {
        self.data = data
        self.onTap = onTap
    }

    /// The main layout of the account preference card.
    var body: some View {
        HStack(alignment: .center, spacing: BankingTheme.dimens.smallMedium) {
            VStack(alignment: .leading, spacing: BankingTheme.dimens.smallMedium) {
                /// Displays the primary and secondary text
                AccountTextSection(
                    primaryText: data.primaryText,
                    secondaryText: data.secondaryText
                )
                .onPreferenceChange(ContainerFramePreferenceKey.self) { frame in
                    containerWidth = frame.width
                }

                /// Displays badge indicators if available
                if !data.badgeIndicators.isEmpty {
                    BadgeIndicatorListView(
                        badges: data.badgeIndicators,
                        containerWidth: containerWidth
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            /// Displays a debit card if available
            if data.showMiniCard {
                MiniCardView()
            }

            /// Displays a chevron icon on the right
            ListCellIconView(imageName: BankingTheme.icons.functional.chevronRight.rawValue)
        }
        .padding(BankingTheme.dimens.medium)
        .background(BankingTheme.colors.surface)
        .cornerRadius(BankingTheme.dimens.smallMedium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            /// Trigger the tap action
            onTap()
        }
    }
}
