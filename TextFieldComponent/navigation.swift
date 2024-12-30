struct BackgroundCardStyle: ViewModifier {
    var horizontalPadding: CGFloat
    var verticalPadding: CGFloat
    var cornerRadius: CGFloat
    var backgroundColor: Color
    var outerPadding: CGFloat

    // Custom initializer with default values
    init(
        horizontalPadding: CGFloat = BankingTheme.dimens.small,
        verticalPadding: CGFloat = BankingTheme.dimens.medium,
        cornerRadius: CGFloat = 10,
        backgroundColor: Color = BankingTheme.colors.illustrationGrey,
        outerPadding: CGFloat = BankingTheme.dimens.medium
    ) {
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.outerPadding = outerPadding
    }

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(backgroundColor)
            .clipShape(
                RoundedRectangle(cornerRadius: cornerRadius)
            )
            .padding(.all, outerPadding)
    }
}

extension View {
    func backgroundCardStyle(
        horizontalPadding: CGFloat = BankingTheme.dimens.small,
        verticalPadding: CGFloat = BankingTheme.dimens.medium,
        cornerRadius: CGFloat = 10,
        backgroundColor: Color = BankingTheme.colors.illustrationGrey,
        outerPadding: CGFloat = BankingTheme.dimens.medium
    ) -> some View {
        modifier(
            BackgroundCardStyle(
                horizontalPadding: horizontalPadding,
                verticalPadding: verticalPadding,
                cornerRadius: cornerRadius,
                backgroundColor: backgroundColor,
                outerPadding: outerPadding
            )
        )
    }
}
