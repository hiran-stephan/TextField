@ViewBuilder
private func HStackOrVStack<Content: View>(
    isPad: Bool,
    alignment: HorizontalAlignment = .center,
    spacing: CGFloat? = nil,
    @ViewBuilder content: () -> Content
) -> some View {
    if isPad {
        HStack(alignment: .top, spacing: spacing) {
            content()
        }
    } else {
        VStack(alignment: alignment, spacing: spacing) {
            content()
        }
    }
}

private func buttonSection() -> some View {
    let isPad = UIDevice.current.userInterfaceIdiom == .pad

    return HStackOrVStack(isPad: isPad, alignment: .leading, spacing: BankingTheme.dimens.medium) {
        if isPad {
            SecondaryButton(
                content: {
                    Text(secondaryButtonText)
                },
                buttonPaddingHorizontal: .zero,
                onSecondaryButtonTap
            )
            PrimaryButton(
                content: {
                    Text(primaryButtonText)
                },
                buttonPaddingHorizontal: .zero,
                onPrimaryButtonTap
            )
        } else {
            PrimaryButton(
                content: {
                    Text(primaryButtonText)
                },
                buttonPaddingHorizontal: .zero,
                onPrimaryButtonTap
            )
            SecondaryButton(
                content: {
                    Text(secondaryButtonText)
                },
                buttonPaddingHorizontal: .zero,
                onSecondaryButtonTap
            )
        }
    }
    .padding(.top, BankingTheme.dimens.extraLarge)
}
