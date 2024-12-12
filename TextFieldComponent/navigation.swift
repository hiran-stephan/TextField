
import SwiftUI
import Koin
import Umbrella

struct AccountPreferenceCard: View {
    // Dynamic properties
    let bodyText: String
    let bodySecondaryText: String
    let badgeIndicators: [BadgeIndicatorData]
    
    init(
        bodyText: String,
        bodySecondaryText: String,
        badgeIndicators: [BadgeIndicatorData] = []
    ) {
        self.bodyText = bodyText
        self.bodySecondaryText = bodySecondaryText
        self.badgeIndicators = badgeIndicators
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: BankingTheme.dimens.smallMedium) {
            VStack(alignment: .leading, spacing: BankingTheme.dimens.small) {
                // Primary and secondary text
                BodyTextView(
                    primaryText: bodyText,
                    secondaryText: bodySecondaryText
                )
                
                // Badge indicators
                if !badgeIndicators.isEmpty {
                    BadgeIndicatorsView(badgeIndicators: badgeIndicators)
                }
            }
            .padding(BankingTheme.dimens.medium)
            .background(BankingTheme.colors.surface)
            .cornerRadius(BankingTheme.dimens.smallMedium)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// Subview for primary and secondary text
struct BodyTextView: View {
    let primaryText: String
    let secondaryText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.dimens.small) {
            // Primary body text
            Text(primaryText)
                .typography(BankingTheme.typography.body)
                .foregroundColor(BankingTheme.colors.textPrimary)
            
            // Secondary body text
            Text(secondaryText)
                .typography(BankingTheme.typography.bodySmall)
                .foregroundColor(BankingTheme.colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(BankingTheme.spacing.noPadding)
    }
}

// Subview for badge indicators
struct BadgeIndicatorsView: View {
    let badgeIndicators: [BadgeIndicatorData]
    
    var body: some View {
        ForEach(badgeIndicators, id: \.id) { badge in
            BadgeIndicator(
                badgeIndicatorType: badge.type,
                labelText: badge.labelText
            )
            .padding(.vertical, BankingTheme.spacing.noPadding)
        }
    }
}

// Supporting model for badge indicators
struct BadgeIndicatorData: Identifiable {
    let id = UUID()
    let type: BadgeIndicatorType
    let labelText: String
}

// Example BadgeIndicator component
struct BadgeIndicator: View {
    let badgeIndicatorType: BadgeIndicatorType
    let labelText: String
    
    var body: some View {
        Text(labelText)
            .padding(8)
            .background(badgeIndicatorType == .passiveReversed ? Color.gray : Color.blue)
            .cornerRadius(4)
    }
}

enum BadgeIndicatorType {
    case passiveReversed
    case active
}

AccountPreferenceCard(
    bodyText: "Account Overview",
    bodySecondaryText: "Lorem ipsum **0001**",
    badgeIndicators: [
        BadgeIndicatorData(type: .passiveReversed, labelText: "Hidden"),
        BadgeIndicatorData(type: .active, labelText: "Visible")
    ]
)


struct AccountPreferenceCardData {
    let bodyText: String
    let bodySecondaryText: String
    let badgeIndicators: [BadgeIndicatorData]
    
    init(
        bodyText: String,
        bodySecondaryText: String,
        badgeIndicators: [BadgeIndicatorData] = []
    ) {
        self.bodyText = bodyText
        self.bodySecondaryText = bodySecondaryText
        self.badgeIndicators = badgeIndicators
    }
}



struct AccountPreferenceCard: View {
    // Data class instance
    let data: AccountPreferenceCardData
    
    init(data: AccountPreferenceCardData) {
        self.data = data
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: BankingTheme.dimens.smallMedium) {
            VStack(alignment: .leading, spacing: BankingTheme.dimens.small) {
                // Primary and secondary text
                BodyTextView(
                    primaryText: data.bodyText,
                    secondaryText: data.bodySecondaryText
                )
                
                // Badge indicators
                if !data.badgeIndicators.isEmpty {
                    BadgeIndicatorsView(badgeIndicators: data.badgeIndicators)
                }
            }
            .padding(BankingTheme.dimens.medium)
            .background(BankingTheme.colors.surface)
            .cornerRadius(BankingTheme.dimens.smallMedium)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


let exampleData = AccountPreferenceCardData(
    bodyText: "Account Overview",
    bodySecondaryText: "Lorem ipsum **0001**",
    badgeIndicators: [
        BadgeIndicatorData(type: .passiveReversed, labelText: "Hidden"),
        BadgeIndicatorData(type: .active, labelText: "Visible")
    ]
)

AccountPreferenceCard(data: exampleData)


struct BadgeIndicatorsView: View {
    let badgeIndicators: [BadgeIndicatorData]

    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 8) // Adjust the size as needed
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(badgeIndicators, id: \.id) { badge in
                BadgeIndicator(
                    badgeIndicatorType: badge.type,
                    labelText: badge.labelText
                )
            }
        }
        .padding(.vertical, BankingTheme.spacing.noPadding)
    }
}


import SwiftUI

struct FlowLayout: View {
    let badges: [BadgeIndicatorData]
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat

    var body: some View {
        var widthAccumulator: CGFloat = 0
        var rows: [[BadgeIndicatorData]] = [[]]
        
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            
            ForEach(badges, id: \.id) { badge in
                let badgeWidth = estimatedBadgeWidth(for: badge.labelText)
                
                if widthAccumulator + badgeWidth > availableWidth {
                    rows.append([badge])
                    widthAccumulator = badgeWidth + horizontalSpacing
                } else {
                    rows[rows.count - 1].append(badge)
                    widthAccumulator += badgeWidth + horizontalSpacing
                }
            }
            
            VStack(alignment: .leading, spacing: verticalSpacing) {
                ForEach(0..<rows.count, id: \.self) { rowIndex in
                    HStack(spacing: horizontalSpacing) {
                        ForEach(rows[rowIndex]) { badge in
                            BadgeIndicator(
                                badgeIndicatorType: badge.type,
                                labelText: badge.labelText
                            )
                        }
                    }
                }
            }
        }
    }
    
    private func estimatedBadgeWidth(for text: String) -> CGFloat {
        // Approximate the badge width; adjust based on design
        let baseWidth = text.count * 10
        return CGFloat(max(baseWidth, 50)) // Minimum badge width of 50
    }
}


struct BadgeIndicatorsView: View {
    let badgeIndicators: [BadgeIndicatorData]

    var body: some View {
        FlowLayout(
            badges: badgeIndicators,
            horizontalSpacing: 8, // Fixed horizontal spacing
            verticalSpacing: 8   // Fixed vertical spacing
        )
        .padding()
    }
}
