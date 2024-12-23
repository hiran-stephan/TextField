Button(action: {
    // Your button action here
}) {
    Text(buttonText)
        .typography(BankingTheme.typography.body)
        .foregroundColor(BankingTheme.colors.textPrimary)
        .underline(true, color: BankingTheme.colors.textPrimary)
        .frame(maxWidth: .infinity, alignment: .topLeading)
}
