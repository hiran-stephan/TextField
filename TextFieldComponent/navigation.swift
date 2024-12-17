public enum BadgeIndicatorType: String {
    case info = "Info"
    case success = "Success"
    case error = "Error"
    case passive = "Passive"
    case passiveReversed = "PassiveReversed"
    case promotion = "Promotion"

    /// Returns the name of the leading image asset associated with the badge type.
    public var leadingImage: any FunctionalIcon {
        switch self {
        case .promotion:
            return BankingTheme.icons.functional.star
        default:
            return BankingTheme.icons.functional.pending
        }
    }

    /// Returns the foreground color of the icon associated with the badge type.
    public var iconForegroundColor: Color {
        switch self {
        case .info:
            return BankingTheme.colors.onInfo
        case .success:
            return BankingTheme.colors.onSuccess
        case .error:
            return BankingTheme.colors.error
        case .passive, .passiveReversed:
            return BankingTheme.colors.textSecondary
        case .promotion:
            return BankingTheme.colors.error
        }
    }

    /// Returns the text color associated with the badge type.
    public var textColor: Color {
        switch self {
        case .info:
            return BankingTheme.colors.onInfo
        case .success:
            return BankingTheme.colors.onSuccess
        case .error:
            return BankingTheme.colors.error
        case .passive, .passiveReversed:
            return BankingTheme.colors.textSecondary
        case .promotion:
            return BankingTheme.colors.error
        }
    }

    /// Returns the background color associated with the badge type.
    public var backgroundColor: Color {
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
