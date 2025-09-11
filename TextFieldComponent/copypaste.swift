public struct TextFieldView<Style: TextFieldViewStyle,
                            TitleView: View, Leading: View, Trailing: View>: View {
    // ...
    private let a11yLabel: String?
    private let a11yHint: String?

    public init(
        style: Style = DefaultTextFieldStyle(),
        isSecure: Binding<Bool> = .constant(false),
        text: Binding<String>,
        placeholder: String? = nil,
        @ViewBuilder titleView: @escaping (() -> TitleView) = { EmptyView() },
        @ViewBuilder leadingView: @escaping (() -> Leading) = { EmptyView() },
        @ViewBuilder trailingView: @escaping (() -> Trailing) = { EmptyView() },
        action: (() -> Void)? = nil,
        a11yLabel: String? = nil,          // NEW
        a11yHint: String? = nil            // NEW
    ) {
        self.style = style
        self._isSecure = isSecure
        self._text = text
        self.placeholder = placeholder ?? ""
        self.titleView = titleView
        self.leadingView = leadingView
        self.trailingView = trailingView
        self.action = action
        self.a11yLabel = a11yLabel
        self.a11yHint  = a11yHint
    }
    // ...
}


private var textField: some View {
    TextField(placeholder, text: $text)
        // your styling…
        .accessibilityLabel(Text(a11yLabel ?? defaultA11yLabel()))
        .accessibilityHint(Text(a11yHint ?? defaultA11yHint()))
        .accessibilityValue(Text(accessibilityValueText()))
        .accessibilityAddTraits(isEnabled ? [] : .isDisabled)
}

private var secureTextField: some View {
    SecureField(placeholder, text: $text)
        // same accessibility as above
        .accessibilityLabel(Text(a11yLabel ?? defaultA11yLabel()))
        .accessibilityHint(Text(a11yHint ?? defaultA11yHint()))
        .accessibilityValue(Text(accessibilityValueText()))
        .accessibilityAddTraits(isEnabled ? [] : .isDisabled)
}

// Helpers for sensible defaults if caller doesn't pass label/hint
private func defaultA11yLabel() -> String {
    // Prefer title if you have one; fallback to placeholder → “Text field”
    placeholder.isEmpty ? "Text field" : placeholder
}

private func defaultA11yHint() -> String {
    isEnabled ? "Double-tap to edit" : "Disabled"
}

private func accessibilityValueText() -> String {
    text.isEmpty ? placeholder : text
}


extension TextFieldView where TitleView == TextFieldTitleView {
    public init(
        style: Style = DefaultTextFieldStyle(),
        isSecure: Binding<Bool> = .constant(false),
        text: Binding<String>,
        placeholder: String? = nil,
        title: String,
        // …
        a11yLabel: String? = nil,
        a11yHint: String? = nil
    ) {
        self.init(
            style: style,
            isSecure: isSecure,
            text: text,
            placeholder: placeholder,
            titleView: { TextFieldTitleView(title: title) },
            leadingView: { EmptyView() },
            trailingView: { EmptyView() },
            action: nil,
            a11yLabel: a11yLabel,
            a11yHint: a11yHint
        )
    }
}


Button(action: { isPopupSelectorPresented = true }) {
    TextFieldView(
        text: $selectedAccount,
        placeholder: placeholder,
        trailingView: {
            TextFieldTrailingView(icon: BankingTheme.icons.functional.chevronDown.rawValue)
        },
        a11yLabel: "Selected account",
        a11yHint:  "Opens account selector"
    )
    .environment(\.isEnabled, false)   // read-only display
}


