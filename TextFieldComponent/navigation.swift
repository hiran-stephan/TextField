public struct TextFieldGeneral: View {
    @Binding var text: String
    var enabled: Bool = true
    var label: String
    var labelIcon: String?
    var leadingIcon: String?
    var trailingIcon: String?
    var trailingIconForegroundColor: Color?
    var placeholder: String?
    var isError: Bool = false
    var errorMessage: String?
    var infoMessage: String?
    var infoInlineAlertMode: InlineAlert.Mode = .borderless(hasIcon: true)
    var trailingIconAccessibilityLabel: String?
    var onTrailingIconClicked: (() -> Void)?
    var onQuickTipClicked: (() -> Void)?
    var characterValidation: ((Character) -> Bool)? // New validation closure

    public init(
        text: Binding<String>,
        enabled: Bool = true,
        label: String,
        labelIcon: String? = nil,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        trailingIconForegroundColor: Color? = nil,
        placeholder: String? = nil,
        isError: Bool = false,
        errorMessage: String? = nil,
        infoMessage: String? = nil,
        infoInlineAlertMode: InlineAlert.Mode = .borderless(hasIcon: true),
        trailingIconAccessibilityLabel: String? = nil,
        onTrailingIconClicked: (() -> Void)? = nil,
        onQuickTipClicked: (() -> Void)? = nil,
        characterValidation: ((Character) -> Bool)? = nil // Initialize validation closure
    ) {
        self._text = text
        self.enabled = enabled
        self.label = label
        self.labelIcon = labelIcon
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.trailingIconForegroundColor = trailingIconForegroundColor
        self.placeholder = placeholder
        self.isError = isError
        self.errorMessage = errorMessage
        self.infoMessage = infoMessage
        self.infoInlineAlertMode = infoInlineAlertMode
        self.trailingIconAccessibilityLabel = trailingIconAccessibilityLabel
        self.onTrailingIconClicked = onTrailingIconClicked
        self.onQuickTipClicked = onQuickTipClicked
        self.characterValidation = characterValidation
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TextFieldGeneralTheme.Spacing.errorTextTopPadding) {
            labelView
            textFieldView
            messageView
        }
        .padding(.horizontal, TextFieldGeneralTheme.Spacing.containerPadding)
    }

    private var textFieldView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: TextFieldGeneralTheme.Spacing.cornerRadius)
                .fill(isError ? TextFieldGeneralTheme.Colors.errorBgColor : TextFieldGeneralTheme.Colors.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: TextFieldGeneralTheme.Spacing.cornerRadius)
                        .stroke(isError ? TextFieldGeneralTheme.Colors.errorColor : TextFieldGeneralTheme.Colors.borderColor, lineWidth: 1)
                )
                .frame(height: TextFieldGeneralTheme.Spacing.textFieldHeight)

            HStack {
                if let icon = leadingIcon {
                    ComponentImage(icon, resizable: true)
                        .foregroundColor(enabled ? TextFieldGeneralTheme.Colors.primaryTextColor : TextFieldGeneralTheme.Colors.disabledTextColor)
                        .frame(height: TextFieldGeneralTheme.Spacing.leadingIconHeight)
                }

                TextField(placeholder ?? "", text: $text)
                    .disabled(!enabled)
                    .font(TextFieldGeneralTheme.Fonts.labelFont)
                    .foregroundColor(enabled ? BankingTheme.colors.textPrimary : TextFieldGeneralTheme.Colors.disabledTextColor)
                    .background(Color.clear)
                    .frame(height: TextFieldGeneralTheme.Spacing.textFieldHeight)
                    .onChange(of: text) { newValue in
                        if let validation = characterValidation {
                            text = newValue.filter { validation($0) }
                        }
                    }

                if let icon = trailingIcon {
                    Button(action: { onTrailingIconClicked?() }) {
                        ComponentImage(icon, resizable: true)
                            .foregroundColor(trailingIconForegroundColor ?? (enabled ? TextFieldGeneralTheme.Colors.primaryTextColor : TextFieldGeneralTheme.Colors.disabledTextColor))
                            .frame(height: TextFieldGeneralTheme.Spacing.trailingIconHeight)
                    }
                }
            }
        }
    }

    // Other views (labelView, messageView, etc.) remain unchanged
}

TextFieldGeneral(
    text: $inputText,
    label: "Enter Text",
    characterValidation: { character in
        // Allow only alphabetic characters
        character.isLetter
    }
)


TextField(placeholder ?? "", text: $text)
    .disabled(!enabled)
    .font(TextFieldGeneralTheme.Fonts.labelFont)
    .foregroundColor(enabled ? BankingTheme.colors.textPrimary : TextFieldGeneralTheme.Colors.disabledTextColor)
    .background(Color.clear)
    .frame(height: TextFieldGeneralTheme.Spacing.textFieldHeight)
    .onChange(of: text) { newValue in
        if let validation = characterValidation {
            if validation(newValue) {
                // If the entire text passes validation, update it
                text = newValue
            } else {
                // Revert to the previous valid text
                text = text
            }
        }
    }

var textValidation: ((String) -> Bool)?

TextFieldGeneral(
    text: $inputText,
    label: "Enter Text",
    textValidation: { input in
        // Allow only text with alphabetic characters and a max length of 10
        input.allSatisfy { $0.isLetter } && input.count <= 10
    }
)

