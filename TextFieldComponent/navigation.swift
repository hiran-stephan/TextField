public struct AdaptiveStack<Content: View>: View {
    private let horizontalAlignment: HorizontalAlignment
    private let verticalAlignment: VerticalAlignment
    private let horizontalSpacing: CGFloat?
    private let verticalSpacing: CGFloat?
    private let content: (Bool) -> Content // `isPad` determines order

    public init(
        horizontalAlignment: HorizontalAlignment = .center,
        verticalSpacing: CGFloat? = nil,
        verticalAlignment: VerticalAlignment = .center,
        horizontalSpacing: CGFloat? = nil,
        @ViewBuilder content: @escaping (Bool) -> Content
    ) {
        self.horizontalAlignment = horizontalAlignment
        self.horizontalSpacing = horizontalSpacing
        self.verticalAlignment = verticalAlignment
        self.verticalSpacing = verticalSpacing
        self.content = content
    }

    public var body: some View {
        let isPad = UIDevice.current.userInterfaceIdiom == .pad

        Group {
            if isPad {
                HStack(alignment: verticalAlignment, spacing: horizontalSpacing) {
                    content(isPad) // Pass `isPad` to decide order
                }
            } else {
                VStack(alignment: horizontalAlignment, spacing: verticalSpacing) {
                    content(isPad) // Pass `isPad` to decide order
                }
            }
        }
    }
}



private func buttonSection() -> some View {
    AdaptiveStack(
        verticalSpacing: BankingTheme.dimens.medium,
        horizontalSpacing: BankingTheme.dimens.medium
    ) { isPad in
        if isPad {
            // iPad: Secondary button first, Primary button second
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
            // iPhone: Primary button first, Secondary button second
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
