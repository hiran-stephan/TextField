import SwiftUI
// TODO: Localization to be done
// TextFieldGeneral Component
public struct TextFieldGeneral: View {
    /// The text entered by the user, bound to an external state.
    @Binding var text: String

    /// A Boolean value that determines whether the text field is enabled.
    var enabled: Bool = true

    /// The label text displayed above the text field.
    var label: String

    /// An optional image name for an icon displayed next to the label.
    var labelIcon: String? = nil

    /// An optional image name for an icon displayed inside the text field, before the text.
    var leadingIcon: String? = nil

    /// An optional image name for an icon displayed inside the text field, after the text.
    var trailingIcon: String? = nil

    /// The placeholder text displayed when the text field is empty.
    var placeholder: String? = nil

    /// A Boolean value that indicates whether the text field is in an error state.
    var isError: Bool

    /// The error message displayed below the text field when `isError` is true.
    var errorText: String? = nil

    /// The error message displayed below the text field when `isError` is true.
    var errorIcon: String? = nil

    /// A closure executed when the trailing icon is tapped.
    var onTrailingIconClicked: (() -> Void)? = nil

    /// A closure executed when the quick tip icon next to the label is tapped.
    var onQuickTipClicked: (() -> Void)? = nil

    // Initializer
    public init(
        text: Binding<String>,
        enabled: Bool = true,
        label: String,
        labelIcon: String? = nil,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        placeholder: String? = nil,
        isError: Bool,
        errorText: String? = nil,
        errorIcon: String? = nil,
        onTrailingIconClicked: (() -> Void)? = nil,
        onQuickTipClicked: (() -> Void)? = nil
    ) {
        self._text = text
        self.enabled = enabled
        self.label = label
        self.labelIcon = labelIcon
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.placeholder = placeholder
        self.isError = isError
        self.errorText = errorText
        self.errorIcon = errorIcon
        self.onTrailingIconClicked = onTrailingIconClicked
        self.onQuickTipClicked = onQuickTipClicked
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TextFieldGeneralTheme.Spacing.errorTextTopPadding) {
            labelView
            textFieldView
            if isError, let text = errorText {
                errorMessageView(text: text)
            }
        }
        .padding(.horizontal, TextFieldGeneralTheme.Spacing.containerPadding)
        .accessibilityElement(children: .combine)
    }

    private var labelView: some View {
        HStack(alignment: .center, spacing: TextFieldGeneralTheme.Spacing.iconPadding) {
            Text(label)
                .font(TextFieldGeneralTheme.Fonts.labelFont)
            if let icon = labelIcon {
                Button(action: { onQuickTipClicked?() }) {
                    ComponentImage(icon, resizable: false)
                        .frame(width: TextFieldGeneralTheme.Spacing.labelIconHeight, height: TextFieldGeneralTheme.Spacing.labelIconHeight)
                }
            }
        }
        .frame(height: TextFieldGeneralTheme.Spacing.labelHeight)
    }

    private var textFieldView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: TextFieldGeneralTheme.Spacing.cornerRadius)
                .fill(isError ? TextFieldGeneralTheme.Colors.errorBgColor : TextFieldGeneralTheme.Colors.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: TextFieldGeneralTheme.Spacing.cornerRadius)
                        .stroke(isError ? TextFieldGeneralTheme.Colors.errorColor : TextFieldGeneralTheme.Colors.borderColor, lineWidth: 1)
                )
            HStack {
                if let icon = leadingIcon {
                    ComponentImage(icon)
                        .foregroundColor(enabled ? TextFieldGeneralTheme.Colors.primaryTextColor : TextFieldGeneralTheme.Colors.disabledTextColor)
                        .padding(.leading, TextFieldGeneralTheme.Spacing.iconPadding)
                        .frame(height: TextFieldGeneralTheme.Spacing.leadingIconHeight)
                }
                TextField(placeholder ?? "", text: $text)
                    .font(TextFieldGeneralTheme.Fonts.labelFont)
                    .padding(.leading, leadingIcon == nil ? TextFieldGeneralTheme.Spacing.textFieldPadding : TextFieldGeneralTheme.Spacing.leadingTextFieldPadding)
                    .frame(height: TextFieldGeneralTheme.Spacing.textFieldHeight)
                    .disabled(!enabled)
                if let icon = trailingIcon {
                    Button(action: { onTrailingIconClicked?() }) {
                        ComponentImage(icon)
                            .foregroundColor(enabled ? TextFieldGeneralTheme.Colors.primaryTextColor : TextFieldGeneralTheme.Colors.disabledTextColor)
                            .padding(.trailing, TextFieldGeneralTheme.Spacing.iconPadding)
                            .frame(height: TextFieldGeneralTheme.Spacing.trailingIconHeight)
                    }
                }
            }
            .padding(.horizontal, TextFieldGeneralTheme.Spacing.iconPadding)
            .frame(height: TextFieldGeneralTheme.Spacing.textFieldHeight)
        }
    }

    private func errorMessageView(text: String) -> some View {
        HStack {
            if let icon = errorIcon {
                ComponentImage(icon)
                    .foregroundColor(TextFieldGeneralTheme.Colors.errorColor)
            }
            Text(text)
                .foregroundColor(TextFieldGeneralTheme.Colors.errorColor)
                .font(TextFieldGeneralTheme.Fonts.errorFont)
        }
        .frame(height: TextFieldGeneralTheme.Spacing.errorContainerHeight)
    }
    
}

// Extension to Dismiss Keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
/*
// Usage Examples
// Basic Usage: Create a simple text field with a label and placeholder.
struct ContentView: View {
    @State private var text: String = ""

    var body: some View {
        TextFieldGeneral(
            text: $text,
            label: "Username",
            placeholder: "Enter your username",
            isError: false
        )
        .padding()
    }
}

// With Leading and Trailing Icons: Add icons inside the text field to indicate actions or provide additional context.
struct ContentView: View {
    @State private var text: String = ""

    var body: some View {
        TextFieldGeneral(
            text: $text,
            label: "Password",
            trailingIcon: TextFieldGeneralTheme.Images.trailingIconPassword,
            placeholder: "Enter your password",
            isError: false,
            onTrailingIconClicked: {
                print("Trailing icon clicked")
            }
        )
        .padding()
    }
}

// Handling Error States: Display an error state with a message when validation fails.
struct ContentView: View {
    @State private var text: String = ""
    @State private var showError: Bool = false

    var body: some View {
        VStack {
            TextFieldGeneral(
                text: $text,
                label: "Email",
                placeholder: "Enter your email",
                isError: showError,
                errorIcon: TextFieldGeneralTheme.Images.errorIcon,
                errorText: "Invalid email address"
            )
            .padding()

            Button(action: {
                showError.toggle()
            }) {
                Text(showError ? "Hide Error" : "Show Error")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}
*/
