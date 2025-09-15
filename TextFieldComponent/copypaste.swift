import SwiftUI

public struct TextFieldView<
    Style: TextFieldViewStyle,
    TitleView: View,
    Leading: View,
    Trailing: View
>: View {

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.inputFieldState) private var inputFieldState
    @FocusState private var isFocused: Bool

    // MARK: - Bindings
    @Binding private var text: String
    @Binding private var isSecure: Bool {
        didSet {
            if isSecure {
                isFocused = true
            }
        }
    }

    // MARK: - Semantics & Presentation
    let placeholder: String
    private let titleText: String?                // 🔹 semantic title for a11y/testing
    private let accessibilityLabel: String?
    private let accessibilityHint: String?

    private var style: Style

    let titleView: () -> TitleView
    let leadingView: () -> Leading
    let trailingView: () -> Trailing
    let action: (() -> Void)?

    // MARK: - Base (source-compatible) initializer
    public init(
        style: Style = DefaultTextFieldStyle(),
        isSecure: Binding<Bool> = .constant(false),
        text: Binding<String>,
        placeholder: String? = nil,
        title: String? = nil,                        // 🔹 new (optional to keep compatibility)
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        @ViewBuilder titleView: @escaping () -> TitleView = { EmptyView() },
        @ViewBuilder leadingView: @escaping () -> Leading = { EmptyView() },
        @ViewBuilder trailingView: @escaping () -> Trailing = { EmptyView() },
        action: (() -> Void)? = nil
    ) {
        self.style = style
        self._isSecure = isSecure
        self._text = text
        self.placeholder = placeholder ?? ""
        self.titleText = title
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.titleView = titleView
        self.leadingView = leadingView
        self.trailingView = trailingView
        self.action = action
    }

    // MARK: - Body
    public var body: some View {
        VStack(alignment: .leading, spacing: TextFieldGeneralTheme.Spacing.errorTextTopPadding) {
            titleView()
            makeTextFieldView()
                .focused($isFocused)
                .inputFieldOverlay(inputFieldState, isFocused: isFocused)
        }
    }

    @ViewBuilder
    private func makeTextFieldView() -> some View {
        HStack {
            leadingView()
            if isSecure {
                secureTextField
            } else {
                textField
            }
            trailingView()
        }
        .environment(\.isEnabled, true)
        .padding(.horizontal, TextFieldGeneralTheme.Spacing.containerPadding)
        .modifier(style)
        .onSubmit { action?() }
    }

    private var textField: some View {
        TextField(placeholder, text: $text)
            .applyA11y(label: accessibilityLabel ?? titleText,
                       hint: accessibilityHint ?? nonEmpty(placeholder))
    }

    private var secureTextField: some View {
        SecureField(placeholder, text: $text)
            .applyA11y(label: accessibilityLabel ?? titleText,
                       hint: accessibilityHint ?? nonEmpty(placeholder))
    }
}

// MARK: - A11y Helper
private extension View {
    func applyA11y(label: String?, hint: String?) -> some View {
        self
            .accessibilityLabel(Text(label ?? ""))
            .accessibilityHint(Text(hint ?? ""))
    }
}

// Avoid empty string as a hint
private func nonEmpty(_ value: String?) -> String? {
    guard let v = value, !v.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
    return v
}



// TitleView = TextFieldTitleView
extension TextFieldView where TitleView == TextFieldTitleView {
    public init(
        style: Style = DefaultTextFieldStyle(),
        isSecure: Binding<Bool> = .constant(false),
        text: Binding<String>,
        placeholder: String? = nil,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        title: String,                                            // ✅ required
        tooltip: @escaping @autoclosure () -> ToolTipButton? = nil,
        @ViewBuilder leadingView: @escaping () -> Leading = { EmptyView() },
        @ViewBuilder trailingView: @escaping () -> Trailing = { EmptyView() },
        action: (() -> Void)? = nil
    ) {
        self.init(
            style: style,
            isSecure: isSecure,
            text: text,
            placeholder: placeholder,
            title: title,                                         // 🔹 pass semantic title
            accessibilityLabel: accessibilityLabel,
            accessibilityHint: accessibilityHint,
            titleView: { TextFieldTitleView(title: title, tooltip: tooltip()) },
            leadingView: leadingView,
            trailingView: trailingView,
            action: action
        )
    }
}

// TitleView = TextFieldTitleView, Leading = TextFieldLeadingView
extension TextFieldView where TitleView == TextFieldTitleView, Leading == TextFieldLeadingView {
    public init(
        style: Style = DefaultTextFieldStyle(),
        isSecure: Binding<Bool> = .constant(false),
        text: Binding<String>,
        placeholder: String? = nil,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        title: String,                                            // ✅ required
        tooltip: @escaping @autoclosure () -> ToolTipButton? = nil,
        leadingIcon: String,
        @ViewBuilder trailingView: @escaping () -> Trailing = { EmptyView() },
        action: (() -> Void)? = nil
    ) {
        self.init(
            style: style,
            isSecure: isSecure,
            text: text,
            placeholder: placeholder,
            title: title,                                         // 🔹 pass semantic title
            accessibilityLabel: accessibilityLabel,
            accessibilityHint: accessibilityHint,
            titleView: { TextFieldTitleView(title: title, tooltip: tooltip()) },
            leadingView: { TextFieldLeadingView(icon: leadingIcon) },
            trailingView: trailingView,
            action: action
        )
    }
}
