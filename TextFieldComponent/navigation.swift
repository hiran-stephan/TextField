Row(
    modifier = Modifier.fillMaxWidth(),
    horizontalArrangement = Arrangement.spacedBy(BankingTheme.dimens.small)
) {
    Text(
        text = stepText,
        style = BankingTheme.typography.heading.small,
        color = BankingTheme.colors.textPrimary,
        modifier = Modifier.semantics {
            contentDescription = stepAccessibilityText
        }
    )

    Text(
        text = headingText,
        style = BankingTheme.typography.heading.small,
        color = BankingTheme.colors.textPrimary,
        modifier = Modifier.semantics {
            contentDescription = headingAccessibilityText
        }
    )
}
