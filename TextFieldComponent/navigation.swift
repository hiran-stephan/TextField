/// A data model representing the content and configuration for an account preference card.
struct AccountPreferenceCardData {
    /// The primary text displayed on the card.
    let primaryText: String
    /// The secondary text displayed on the card, if any.
    let secondaryText: String
    /// A Boolean flag indicating whether to display the mini card.
    let showMiniCard: Bool
    /// An array of badge indicators displayed on the card.
    let badgeIndicators: [BadgeIndicatorData]

    /// Initializes a new `AccountPreferenceCardData` instance.
    /// - Parameters:
    ///   - primaryText: The primary text to display on the card.
    ///   - secondaryText: The secondary text to display on the card.
    ///   - showMiniCard: A Boolean flag indicating whether to display the mini card. Defaults to `false`.
    ///   - badgeIndicators: An array of badge indicators to display on the card. Defaults to an empty array.
    init(
        primaryText: String,
        secondaryText: String,
        showMiniCard: Bool = false,
        badgeIndicators: [BadgeIndicatorData] = []
    ) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.showMiniCard = showMiniCard
        self.badgeIndicators = badgeIndicators
    }
}

