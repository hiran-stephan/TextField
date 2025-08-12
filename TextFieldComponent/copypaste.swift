Text(model.message)
    .foregroundColor(BankingTheme.colors.textPrimary)
    .font(BankingTheme.typography.bodySmall)
    .multilineTextAlignment(.leading)
    .lineLimit(nil) // allow multiple lines
    .fixedSize(horizontal: false, vertical: true) // expand vertically as needed
