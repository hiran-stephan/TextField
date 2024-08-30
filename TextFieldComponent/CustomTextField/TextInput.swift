import SwiftUI

// TextFieldGeneral Component
struct TextInput: View {
    /// The text entered by the user, bound to an external state.
    @Binding var text: String

    /// A Boolean value that determines whether the text field is enabled.
    var enabled: Bool = true

    /// The label text displayed above the text field.
    var label: String

    /// An optional system image name for an icon displayed next to the label.
    var labelIcon: String? = nil

    /// An optional system image name for an icon displayed inside the text field, before the text.
    var leadingIcon: String? = nil

    /// An optional system image name for an icon displayed inside the text field, after the text.
    var trailingIcon: String? = nil

    /// The placeholder text displayed when the text field is empty.
    var placeholder: String? = nil

    /// A Boolean value that indicates whether the text field is in an error state.
    var isError: Bool

    /// The error message displayed below the text field when `isError` is true.
    var errorText: String? = nil

    /// A closure executed when the trailing icon is tapped.
    var onTrailingIconClicked: (() -> Void)? = nil

    /// A closure executed when the quick tip icon next to the label is tapped.
    var onQuickTipClicked: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: TextInputTheme.Spacing.errorTextTopPadding) {
            labelView
            textFieldView
            if isError, let text = errorText {
                errorMessageView(text: text)
            }
        }
        .padding(.horizontal, TextInputTheme.Spacing.containerPadding)
        .accessibilityElement(children: .combine)
    }

    private var labelView: some View {
        HStack(alignment: .center, spacing: TextInputTheme.Spacing.iconPadding) {
            Text(label)
                .font(TextInputTheme.Fonts.labelFont)
                .accessibilityLabel(Text(label))
            if let icon = labelIcon {
                Button(action: { onQuickTipClicked?() }) {
                    Image(systemName: icon)
                        .resizable()
                        .frame(width: TextInputTheme.Spacing.iconSize, height: TextInputTheme.Spacing.iconSize)
                        .accessibilityLabel(Text("Quick Tip"))
                }
            }
        }
        .frame(height: TextInputTheme.Spacing.labelHeight)
    }

    private var textFieldView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: TextInputTheme.Spacing.cornerRadius)
                .fill(isError ? TextInputTheme.Colors.errorColor : TextInputTheme.Colors.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: TextInputTheme.Spacing.cornerRadius)
                        .stroke(isError ? TextInputTheme.Colors.errorColor : TextInputTheme.Colors.borderColor, lineWidth: 1)
                )
                .frame(height: TextInputTheme.Spacing.textFieldHeight)

            HStack {
                if let icon = leadingIcon {
                    Image(systemName: icon)
                        .foregroundColor(enabled ? TextInputTheme.Colors.primaryTextColor : TextInputTheme.Colors.disabledTextColor)
                        .padding(.leading, TextInputTheme.Spacing.iconPadding)
                        .frame(height: TextInputTheme.Spacing.textFieldHeight)
                        .accessibilityLabel(Text("Leading Icon"))
                }

                TextField(placeholder ?? "", text: $text)
                    .disabled(!enabled)
                    .padding(.leading, leadingIcon == nil ? TextInputTheme.Spacing.leadingTextFieldPadding : 0)
                    .padding(.vertical, TextInputTheme.Spacing.textFieldPadding)
                    .background(Color.clear)
                    .frame(height: TextInputTheme.Spacing.textFieldHeight)
                    .accessibilityLabel(Text(placeholder ?? label))

                if let icon = trailingIcon {
                    Button(action: { onTrailingIconClicked?() }) {
                        Image(systemName: icon)
                            .foregroundColor(enabled ? TextInputTheme.Colors.primaryTextColor : TextInputTheme.Colors.disabledTextColor)
                            .padding(.trailing, TextInputTheme.Spacing.iconPadding)
                            .frame(height: TextInputTheme.Spacing.textFieldHeight)
                            .accessibilityLabel(Text("Trailing Icon"))
                    }
                }
            }
            .padding(.horizontal, TextInputTheme.Spacing.iconPadding)
        }
    }

    private func errorMessageView(text: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.circle")
                .foregroundColor(TextInputTheme.Colors.errorColor)
            Text(text)
                .foregroundColor(TextInputTheme.Colors.errorColor)
                .font(TextInputTheme.Fonts.errorFont)
        }
        .accessibilityLabel(Text("Error: \(text)"))
    }
}

// Extension to Dismiss Keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

