protocol CardStyle {
    associatedtype Body: View
    func body(content: Content) -> Body
}


struct DefaultCardStyle: CardStyle {
    var borderColor: Color = BankingTheme.colors.borderDefault
    var lineWidth: CGFloat = 1
    var cornerRadius: CGFloat = 12
    var backgroundColor: Color = BankingTheme.colors.surfaceVariant
    var paddingHorizontal: CGFloat = 16
    var paddingVertical: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, paddingHorizontal)
            .padding(.vertical, paddingVertical)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: lineWidth)
            )
    }
}


public struct ListCardContainer<Content: View, Style: CardStyle>: View {
    private let content: () -> Content
    private let style: Style

    public init(
        style: Style = DefaultCardStyle(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.content = content
    }

    public var body: some View {
        style.body(content: content())
    }
}


struct RedCardStyle: CardStyle {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(Color.red)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white, lineWidth: 2)
            )
    }
}
