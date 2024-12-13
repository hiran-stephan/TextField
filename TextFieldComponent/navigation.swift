/// A SwiftUI view that represents a badge indicator with optional leading icon and customizable text and styling.
public struct BadgeIndicator: View {
    /// The type of badge indicator, which defines its styling and icon.
    let badgeIndicatorType: BadgeIndicatorType
    /// The text displayed inside the badge.
    let text: String
    /// A flag indicating whether to show the leading icon.
    let showIcon: Bool

    /// Initializes a new instance of `BadgeIndicator`.
    /// - Parameters:
    ///   - badgeIndicatorType: The type of badge indicator, which defines its style and behavior.
    ///   - text: The text displayed within the badge.
    ///   - showIcon: A Boolean value that determines whether the leading icon is shown. Defaults to `false`.
    public init(
        badgeIndicatorType: BadgeIndicatorType,
        text: String,
        showIcon: Bool = false
    ) {
        self.badgeIndicatorType = badgeIndicatorType
        self.text = text
        self.showIcon = showIcon
    }

    /// The content and layout of the badge indicator.
    public var body: some View {
        HStack(alignment: .center, spacing: BankingTheme.dimens.microSmall) {
            // Display the leading icon if `showIcon` is true
            if showIcon {
                ComponentImage(self.badgeIndicatorType.leadingImage())
                    .frame(
                        width: BankingTheme.spacing.smallIconSize,
                        height: BankingTheme.spacing.smallIconSize
                    )
            }

            // Display the badge text
            Text(text)
                .typography(BankingTheme.typography.bodySmall)
                .foregroundColor(self.badgeIndicatorType.textColor())
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, BankingTheme.dimens.smallMedium)
        .padding(.vertical, BankingTheme.dimens.microSmall)
        .background(self.badgeIndicatorType.backgroundColor())
        .cornerRadius(BankingTheme.dimens.mediumLarge)
        .overlay(
            GeometryReader { geometry in
                Color.clear
                    .preference(
                        key: BadgeWidthPreferenceKey.self,
                        value: [geometry.size.width]
                    )
            }
        )
    }
}
