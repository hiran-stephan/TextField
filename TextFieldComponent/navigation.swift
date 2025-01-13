import Foundation
import SwiftUI
import Theme

/// A protocol representing a customizable card style.
public protocol CardStyle {
    /// Configures the appearance of the card.
    /// - Parameter content: The content to be displayed inside the card.
    /// - Returns: A view with the styled card appearance.
    func body<Content: View>(content: Content) -> AnyView
}

/// The default card style with a border, background, and corner radius.
public struct DefaultCardStyle: CardStyle {
    var borderColor: Color = BankingTheme.colors.borderDefault
    var lineWidth: CGFloat = BankingTheme.spacing.stroke
    var cornerRadius: CGFloat = BankingTheme.dimens.smallMedium
    var backgroundColor: Color = BankingTheme.colors.surfaceVariant

    public init() {}

    public func body<Content: View>(content: Content) -> AnyView {
        AnyView(
            content
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: lineWidth)
                )
        )
    }
}

/// A plain card style with no additional decorations.
public struct PlainCardStyle: CardStyle {
    public init() {}

    public func body<Content: View>(content: Content) -> AnyView {
        AnyView(content)
    }
}

/// A borderless card style with customizable corner radius.
public struct BorderlessCardStyle: CardStyle {
    var cornerRadius: CGFloat = BankingTheme.dimens.smallMedium

    public init() {}

    public func body<Content: View>(content: Content) -> AnyView {
        AnyView(
            content
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        )
    }
}

/// A container for wrapping content inside a card with a customizable style.
public final struct ListCardContainer<Content: View, Style: CardStyle>: View {
    private let content: () -> Content
    private let style: Style

    /// Initializes the container with a specific style and content.
    /// - Parameters:
    ///   - style: The card style to apply. Defaults to `DefaultCardStyle`.
    ///   - content: The content to be displayed inside the card.
    public init(
        style: Style = DefaultCardStyle(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.content = content
    }

    /// The body of the `ListCardContainer` which applies the selected style.
    public var body: some View {
        style.body(content: content())
    }
}
