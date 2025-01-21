public protocol EmptyStateStyle {
    associatedtype Body: View
    func body(content: AnyView) -> Body
}

public struct EmptyState<Style: EmptyStateStyle, ImageView: View, ContentView: View, ActionView: View>: View {
    private let style: Style
    private let imageView: (() -> ImageView)?
    private let contentView: (() -> ContentView)?
    private let actionView: (() -> ActionView)?

    public init(
        style: Style,
        @ViewBuilder imageView: (() -> ImageView)? = nil,
        @ViewBuilder contentView: (() -> ContentView)? = nil,
        @ViewBuilder actionView: (() -> ActionView)? = nil
    ) {
        self.style = style
        self.imageView = imageView
        self.contentView = contentView
        self.actionView = actionView
    }

    public var body: some View {
        let content = VStack(spacing: 16) {
            if let imageView = imageView {
                imageView()
            }
            if let contentView = contentView {
                contentView()
            }
            if let actionView = actionView {
                actionView()
            }
        }.eraseToAnyView()

        return style.body(content: content)
    }
}



public struct DefaultEmptyStateStyle: EmptyStateStyle {
    public func body(content: AnyView) -> some View {
        content
            .padding(.horizontal, 28)
            .padding(.vertical, 60)
            .background(BankingTheme.colors.illustrationGrey)
            .cornerRadius(12)
    }
}

public struct PlainEmptyStateStyle: EmptyStateStyle {
    public func body(content: AnyView) -> some View {
        content
            .padding()
    }
}
