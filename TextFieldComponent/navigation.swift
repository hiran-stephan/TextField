/// An enumeration representing different types of badge indicators.
/// Each type determines the associated styling, text color, and background color.
public enum BadgeIndicatorType: String {
    case info = "Info"                  // Represents informational badges.
    case success = "Success"            // Represents success badges.
    case error = "Error"                // Represents error badges.
    case passive = "Passive"            // Represents passive badges.
    case passiveReversed = "PassiveReversed" // Represents reversed passive badges.
    case promotion = "Promotion"        // Represents promotional badges.

    /// Returns the name of the leading image asset associated with the badge type.
    /// - Returns: A `String` representing the image asset name.
    public func leadingImage() -> String {
        switch self {
        case .info:
            return BadgeIndicatorImages.info
        case .success:
            return BadgeIndicatorImages.success
        case .error:
            return BadgeIndicatorImages.error
        case .passive:
            return BadgeIndicatorImages.passive
        case .passiveReversed:
            return BadgeIndicatorImages.passiveReverse
        case .promotion:
            return BadgeIndicatorImages.promotion
        }
    }

    /// Returns the text color associated with the badge type.
    /// - Returns: A `Color` for the text.
    public func textColor() -> Color {
        switch self {
        case .info:
            return BankingTheme.colors.onInfo
        case .success:
            return BankingTheme.colors.statusSuccess
        case .error:
            return BankingTheme.colors.error
        case .passive, .passiveReversed:
            return BankingTheme.colors.textSecondary
        case .promotion:
            return BankingTheme.colors.error
        }
    }

    /// Returns the background color associated with the badge type.
    /// - Returns: A `Color` for the background.
    public func backgroundColor() -> Color {
        switch self {
        case .info:
            return BankingTheme.colors.illustrationBlueShadow
        case .success:
            return BankingTheme.colors.success
        case .error:
            return BankingTheme.colors.errorContainer
        case .passive:
            return BankingTheme.colors.illustrationGrey
        case .passiveReversed, .promotion:
            return BankingTheme.colors.background
        }
    }
}
