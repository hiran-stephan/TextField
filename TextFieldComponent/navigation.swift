// Primary Label Font: Adjusted based on both `style` and `state`
private var primaryLabelFont: Font {
    switch state {
    case .default:
        return style == .boxed ? BankingTheme.typography.bodyBold : BankingTheme.typography.bodySemiBold
    case .error:
        return BankingTheme.typography.bodyBold
    case .disabled:
        return BankingTheme.typography.bodySemiBold
    }
}

// Primary Label Color: Changes for different states
private var primaryLabelColor: Color {
    switch state {
    case .default:
        return style == .boxed ? BankingTheme.colors.textSecondary : BankingTheme.colors.textPrimary
    case .error:
        return BankingTheme.colors.error
    case .disabled:
        return BankingTheme.colors.textSecondary.opacity(0.5)
    }
}

// Secondary Label Color: Adjusts for disabled state
private var secondaryLabelColor: Color {
    switch state {
    case .default:
        return BankingTheme.colors.textSecondary
    case .error:
        return BankingTheme.colors.error.opacity(0.8)
    case .disabled:
        return BankingTheme.colors.textSecondary.opacity(0.5)
    }
}

// Label Spacing: Compact vs Boxed difference
private var labelSpacing: CGFloat {
    switch style {
    case .boxed:
        return BankingTheme.dimensions.medium
    case .compact:
        return BankingTheme.dimensions.small
    }
}
