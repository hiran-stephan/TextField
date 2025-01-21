import SwiftUI

public protocol CardStyle {
    func body<Content: View>(content: Content) -> AnyView
}


public struct DefaultEmptyStateStyle: CardStyle {
    var backgroundColor: Color = BankingTheme.colors.illustrationGrey
    var cornerRadius: CGFloat = 12

    public func body<Content: View>(content: Content) -> AnyView {
        AnyView(
            content
                .padding(.horizontal, 28)
                .padding(.vertical, 60)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        )
    }
}

public struct PlainEmptyStateStyle: CardStyle {
    public func body<Content: View>(content: Content) -> AnyView {
        AnyView(
            content
                .padding()
        )
    }
}


public struct EmptyState<Content: View, Style: CardStyle>: View {
    private let content: () -> Content
    private let style: Style

    public init(
        style: Style,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.content = content
    }

    public var body: some View {
        style.body(content: content())
    }
}


EmptyState(style: DefaultEmptyStateStyle()) {
    VStack {
        Text("Default Empty State")
        Image(systemName: "exclamationmark.circle")
    }
}
