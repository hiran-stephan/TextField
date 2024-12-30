private func buttonSection() -> some View {
    let isPad = UIDevice.current.userInterfaceIdiom == .pad

    if isPad {
        return AnyView(
            HStack(alignment: .top, spacing: 16) { // Replace 16 with `BankingTheme.dimens.medium`
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
            }
        )
    } else {
        return AnyView(
            VStack(alignment: .leading, spacing: 16) { // Replace 16 with `BankingTheme.dimens.medium`
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
            .padding(.top, 32) // Replace 32 with `BankingTheme.dimens.extraLarge`
        )
    }
}
