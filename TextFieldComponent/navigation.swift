public struct NoPaddingTextFieldStyle: TextFieldStyle {
    public var foregroundColor: Color = BankingTheme.colors.textPrimary
    public var backgroundColor: Color = .clear
    public var horizontalPadding: CGFloat = 0

    public init() {}

    public func body(content: Content) -> some View {
        content
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .padding(.horizontal, horizontalPadding)
    }
}
