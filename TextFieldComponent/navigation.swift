import SwiftUI

// MARK: - TextFieldStyle Protocol
public protocol TextFieldStyle {
    func hasBackground() -> Bool
    func hasBorder() -> Bool
    func background(isError: Bool) -> Color
    func border(isError: Bool) -> Color
    func cornerRadius() -> CGFloat
    func font() -> Font
    func textColor() -> Color
}

// MARK: - DefaultTextFieldStyle
public struct DefaultTextFieldStyle: TextFieldStyle {
    public init() {}

    public func hasBackground() -> Bool {
        true
    }

    public func hasBorder() -> Bool {
        true
    }

    public func background(isError: Bool) -> Color {
        isError ? TextFieldGeneralTheme.Colors.errorBgColor : TextFieldGeneralTheme.Colors.backgroundColor
    }

    public func border(isError: Bool) -> Color {
        isError ? TextFieldGeneralTheme.Colors.errorColor : TextFieldGeneralTheme.Colors.borderColor
    }

    public func cornerRadius() -> CGFloat {
        TextFieldGeneralTheme.Spacing.cornerRadius
    }

    public func font() -> Font {
        TextFieldGeneralTheme.Fonts.labelFont
    }

    public func textColor() -> Color {
        BankingTheme.colors.textPrimary
    }
}

// MARK: - BorderlessTextFieldStyle
public struct BorderlessTextFieldStyle: TextFieldStyle {
    public init() {}

    public func hasBackground() -> Bool {
        false
    }

    public func hasBorder() -> Bool {
        false
    }

    public func background(isError: Bool) -> Color {
        .clear
    }

    public func border(isError: Bool) -> Color {
        .clear
    }

    public func cornerRadius() -> CGFloat {
        0
    }

    public func font() -> Font {
        TextFieldGeneralTheme.Fonts.labelFont
    }

    public func textColor() -> Color {
        BankingTheme.colors.textPrimary
    }
}

// MARK: - TextFieldGeneral Component
public struct TextFieldGeneral<Label: View, Leading: View, Trailing: View, Message: View>: View {
    @Binding var text: String
    @Binding var isError: Bool
    let placeholder: String
    private let style: TextFieldStyle
    private let labelView: () -> Label
    private let leadingView: () -> Leading
    private let trailingView: () -> Trailing
    private let messageView: () -> Message

    public init(
        text: Binding<String>,
        isError: Binding<Bool>,
        placeholder: String = "",
        style: TextFieldStyle = DefaultTextFieldStyle(),
        @ViewBuilder labelView: @escaping () -> Label = { EmptyView() },
        @ViewBuilder leadingView: @escaping () -> Leading = { EmptyView() },
        @ViewBuilder trailingView: @escaping () -> Trailing = { EmptyView() },
        @ViewBuilder messageView: @escaping () -> Message = { EmptyView() }
    ) {
        self._text = text
        self._isError = isError
        self.placeholder = placeholder
        self.style = style
        self.labelView = labelView
        self.leadingView = leadingView
        self.trailingView = trailingView
        self.messageView = messageView
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TextFieldGeneralTheme.Spacing.errorTextTopPadding) {
            labelView()
            makeTextFieldView()
            messageView()
        }
        .padding(.horizontal, TextFieldGeneralTheme.Spacing.containerPadding)
    }

    @ViewBuilder
    private func makeTextFieldView() -> some View {
        ZStack {
            if style.hasBackground() {
                RoundedRectangle(cornerRadius: style.cornerRadius())
                    .fill(style.background(isError: isError))
            }
            if style.hasBorder() {
                RoundedRectangle(cornerRadius: style.cornerRadius())
                    .stroke(style.border(isError: isError), lineWidth: 1)
            }
            HStack {
                leadingView()
                TextField(placeholder, text: $text)
                    .font(style.font())
                    .foregroundColor(style.textColor())
                    .background(Color.clear)
                    .frame(height: TextFieldGeneralTheme.Spacing.textFieldHeight)
                trailingView()
            }
            .padding(.horizontal, BankingTheme.dimens.medium)
        }
        .frame(height: TextFieldGeneralTheme.Spacing.textFieldHeight)
    }
}

// MARK: - Mock Themes for Preview
public struct TextFieldGeneralTheme {
    public struct Colors {
        static let backgroundColor = Color.gray.opacity(0.1)
        static let errorBgColor = Color.red.opacity(0.1)
        static let borderColor = Color.gray
        static let errorColor = Color.red
    }

    public struct Fonts {
        static let labelFont = Font.body
    }

    public struct Spacing {
        static let cornerRadius: CGFloat = 8
        static let textFieldHeight: CGFloat = 44
        static let errorTextTopPadding: CGFloat = 4
        static let containerPadding: CGFloat = 16
    }
}

public struct BankingTheme {
    public struct colors {
        static let textPrimary = Color.black
    }

    public struct dimens {
        static let medium: CGFloat = 8
    }
}

// MARK: - Preview
struct TextFieldGeneral_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            TextFieldGeneral(
                text: .constant(""),
                isError: .constant(false),
                placeholder: "Default Style",
                style: DefaultTextFieldStyle(),
                labelView: {
                    Text("Default Label")
                },
                messageView: {
                    Text("Error message")
                        .foregroundColor(.red)
                }
            )

            TextFieldGeneral(
                text: .constant(""),
                isError: .constant(false),
                placeholder: "Borderless Style",
                style: BorderlessTextFieldStyle(),
                labelView: {
                    Text("Borderless Label")
                },
                messageView: {
                    Text("No border or background")
                        .foregroundColor(.red)
                }
            )
        }
        .padding()
    }
}
