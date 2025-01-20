public protocol TextFieldStyle {
    func background(isError: Bool) -> Color
    func border(isError: Bool) -> Color
    func cornerRadius() -> CGFloat
    func font() -> Font
    func textColor() -> Color
}

public struct DefaultTextFieldStyle: TextFieldStyle {
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
            RoundedRectangle(cornerRadius: style.cornerRadius())
                .fill(style.background(isError: isError))
            RoundedRectangle(cornerRadius: style.cornerRadius())
                .stroke(style.border(isError: isError), lineWidth: 1)
                .frame(height: TextFieldGeneralTheme.Spacing.textFieldHeight)
            
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
    }
}

TextFieldGeneral(
    text: $text,
    isError: $isError,
    placeholder: "Enter text",
    style: DefaultTextFieldStyle(),
    labelView: {
        Text("Label")
    },
    messageView: {
        Text("Error message")
            .foregroundColor(.red)
    }
)

