import SwiftUI

/// A reusable component for displaying a section with primary and secondary text.
struct AccountTextSection: View {
    /// The primary text to be displayed.
    let primaryText: String
    
    /// The secondary text to be displayed.
    let secondaryText: String
    
    /// Styling for the text section.
    let style: AccountTextSectionStyle
    
    var body: some View {
        VStack(alignment: .leading, spacing: style.spacing) {
            Text(primaryText)
                .font(style.primaryTextFont)
                .foregroundColor(style.primaryTextColor)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(secondaryText)
                .font(style.secondaryTextFont)
                .foregroundColor(style.secondaryTextColor)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(style.padding)
        .background(
            GeometryReader { geometry in
                Color.clear
                    .preference(
                        key: ContainerFramePreferenceKey.self,
                        value: geometry.frame(in: .global)
                    )
            }
        )
    }
}

/// A struct to define the styling for `AccountTextSection`.
struct AccountTextSectionStyle {
    let primaryTextFont: Font
    let secondaryTextFont: Font
    let primaryTextColor: Color
    let secondaryTextColor: Color
    let spacing: CGFloat
    let padding: EdgeInsets
    
    /// Default styling for the section.
    static let `default` = AccountTextSectionStyle(
        primaryTextFont: BankingTheme.typography.headingSmall,
        secondaryTextFont: BankingTheme.typography.bodySmall,
        primaryTextColor: BankingTheme.colors.textPrimary,
        secondaryTextColor: BankingTheme.colors.textSecondary,
        spacing: BankingTheme.spacing.noPadding,
        padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
    )
}

/// A preference key to pass frame data up the view hierarchy.
struct ContainerFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
