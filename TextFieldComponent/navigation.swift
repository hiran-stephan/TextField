private var borderColor: Color {
    if state == .disabled {
        return BankingTheme.colors.disabled
    } else if state == .error && isFocused {
        return BankingTheme.colors.error
    } else if state == .error {
        return BankingTheme.colors.error
    } else if isFocused {
        return BankingTheme.colors.textPrimary
    } else {
        return BankingTheme.colors.textSecondary
    }
}

private var borderWidth: CGFloat {
    (isFocused && state != .disabled) ? 2 : 1
}

private var backgroundColor: Color {
    if state == .disabled {
        return BankingTheme.colors.disabledBackground
    } else if state == .error {
        return BankingTheme.colors.errorContainer
    } else {
        return BankingTheme.colors.onPrimary
    }
}

private var textColor: Color {
    (state == .disabled) ? BankingTheme.colors.disabled : BankingTheme.colors.textPrimary
}


