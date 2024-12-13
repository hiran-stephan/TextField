/// A data model that represents the properties and configuration for a badge indicator.
public struct BadgeIndicatorData: Identifiable, Hashable {
    /// A unique identifier for the badge.
    public var id = UUID().uuidString
    /// The type of badge, which determines its style and behavior.
    public var type: BadgeIndicatorType
    /// The text displayed in the badge.
    public var text: String
    /// A Boolean flag indicating whether to show the leading icon.
    public var showIcon: Bool
    /// The calculated width of the badge, used for layout purposes.
    public var size: CGFloat

    /// Initializes a new `BadgeIndicatorData` instance.
    /// - Parameters:
    ///   - type: The type of the badge.
    ///   - text: The text to be displayed in the badge.
    ///   - showIcon: A Boolean flag indicating whether to show the leading icon. Defaults to `false`.
    ///   - size: The calculated width of the badge. Defaults to `0`.
    public init(
        type: BadgeIndicatorType,
        text: String,
        showIcon: Bool = false,
        size: CGFloat = 0
    ) {
        self.type = type
        self.text = text
        self.showIcon = showIcon
        self.size = size
    }
}



/// A `PreferenceKey` used to pass the width of a badge indicator between views.
public struct BadgeWidthPreferenceKey: PreferenceKey {
    /// The default value for the preference key, which is an empty array of `CGFloat`.
    public static var defaultValue: [CGFloat] = []

    /// Combines the current value with the next value.
    /// - Parameters:
    ///   - value: The current value of the preference key.
    ///   - nextValue: The next value to be added.
    public static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}

/// A SwiftUI view that displays a badge with optional leading icon, customizable text, and styling.
public struct BadgeIndicator: View {
    /// The data used to configure the badge's appearance and content.
    let badgeIndicatorData: BadgeIndicatorData

    /// Initializes a new `BadgeIndicator` instance.
    /// - Parameter badgeIndicatorData: The data object containing the badge's type, text, and configuration.
    public init(badgeIndicatorData: BadgeIndicatorData) {
        self.badgeIndicatorData = badgeIndicatorData
    }

    /// The content and layout of the badge indicator.
    public var body: some View {
        HStack(alignment: .center, spacing: BankingTheme.dimens.microSmall) {
            // Display the leading icon if `showIcon` is true
            if badgeIndicatorData.showIcon {
                ComponentImage(badgeIndicatorData.type.leadingImage())
                    .frame(
                        width: BankingTheme.spacing.smallIconSize,
                        height: BankingTheme.spacing.smallIconSize
                    )
            }

            // Display the badge text
            Text(badgeIndicatorData.text)
                .typography(BankingTheme.typography.bodySmall)
                .foregroundColor(badgeIndicatorData.type.textColor())
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, BankingTheme.dimens.smallMedium)
        .padding(.vertical, BankingTheme.dimens.microSmall)
        .background(badgeIndicatorData.type.backgroundColor())
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
