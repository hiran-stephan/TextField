import SwiftUI

// MARK: - InlineMessage Enum
enum InlineMessage {
    case error(text: String, icon: String? = nil)
    case info(text: String, icon: String? = nil)

    /// Returns the message text.
    func getText() -> String {
        switch self {
        case .error(let text, _): return text
        case .info(let text, _): return text
        }
    }

    /// Returns the icon for the message, if any.
    func getIcon() -> String? {
        switch self {
        case .error(_, let icon): return icon
        case .info(_, let icon): return icon
        }
    }

    /// Returns the appropriate color for the message type.
    func getColor() -> Color {
        switch self {
        case .error: return TextFieldGeneralTheme.Colors.errorColor
        case .info: return TextFieldGeneralTheme.Colors.infoColor
        }
    }
}

// MARK: - TextFieldGeneralTheme
struct TextFieldGeneralTheme {
    struct Colors {
        static let errorColor = Color.red
        static let infoColor = Color.blue
        static let backgroundColor = Color.white
        static let borderColor = Color.gray
        static let primaryTextColor = Color.black
        static let disabledTextColor = Color.gray
    }

    struct Fonts {
        static let labelFont = Font.system(size: 14, weight: .medium)
        static let messageFont = Font.system(size: 12)
    }

    struct Spacing {
        static let containerPadding: CGFloat = 16
        static let messageTopPadding: CGFloat = 8
        static let messageIconHeight: CGFloat = 16
        static let messageContainerHeight: CGFloat = 20
        static let cornerRadius: CGFloat = 8
        static let textFieldHeight: CGFloat = 44
    }
}

// MARK: - TextFieldGeneral Component
public struct TextFieldGeneral: View {
    @Binding var text: String

    var enabled: Bool = true
    var label: String
    var labelIcon: String?
    var leadingIcon: String?
    var trailingIcon: String?
    var trailingIconForegroundColor: Color?
    var placeholder: String?
    var errorMessage: InlineMessage?
    var infoMessage: InlineMessage?
    var trailingIconAccessibilityLabel: String?
    var onTrailingIconClicked: (() -> Void)?
    var onQuickTipClicked: (() -> Void)?

    public init(
        text: Binding<String>,
        enabled: Bool = true,
        label: String,
        labelIcon: String? = nil,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        trailingIconForegroundColor: Color? = nil,
        placeholder: String? = nil,
        errorMessage: InlineMessage? = nil,
        infoMessage: InlineMessage? = nil,
        trailingIconAccessibilityLabel: String? = nil,
        onTrailingIconClicked: (() -> Void)? = nil,
        onQuickTipClicked: (() -> Void)? = nil
    ) {
        self._text = text
        self.enabled = enabled
        self.label = label
        self.labelIcon = labelIcon
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.trailingIconForegroundColor = trailingIconForegroundColor
        self.placeholder = placeholder
        self.errorMessage = errorMessage
        self.infoMessage = infoMessage
        self.trailingIconAccessibilityLabel = trailingIconAccessibilityLabel
        self.onTrailingIconClicked = onTrailingIconClicked
        self.onQuickTipClicked = onQuickTipClicked
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TextFieldGeneralTheme.Spacing.messageTopPadding) {
            labelView
            textFieldView
            messageView()
        }
        .padding(.horizontal, TextFieldGeneralTheme.Spacing.containerPadding)
    }

    private var labelView: some View {
        HStack(alignment: .center, spacing: TextFieldGeneralTheme.Spacing.containerPadding) {
            Text(label)
                .font(TextFieldGeneralTheme.Fonts.labelFont)
            if let icon = labelIcon {
                Button(action: { onQuickTipClicked?() }) {
                    ComponentImage(icon, resizable: true)
                }
                .frame(height: TextFieldGeneralTheme.Spacing.messageIconHeight)
            }
        }
    }

    private var textFieldView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: TextFieldGeneralTheme.Spacing.cornerRadius)
                .fill(TextFieldGeneralTheme.Colors.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: TextFieldGeneralTheme.Spacing.cornerRadius)
                        .stroke(TextFieldGeneralTheme.Colors.borderColor, lineWidth: 1)
                )
                .frame(height: TextFieldGeneralTheme.Spacing.textFieldHeight)

            HStack {
                if let icon = leadingIcon {
                    ComponentImage(icon)
                        .foregroundColor(enabled ? TextFieldGeneralTheme.Colors.primaryTextColor : TextFieldGeneralTheme.Colors.disabledTextColor)
                        .frame(height: TextFieldGeneralTheme.Spacing.messageIconHeight)
                }

                TextField(placeholder ?? "", text: $text)
                    .disabled(!enabled)
                    .font(TextFieldGeneralTheme.Fonts.labelFont)
                    .foregroundColor(enabled ? TextFieldGeneralTheme.Colors.primaryTextColor : TextFieldGeneralTheme.Colors.disabledTextColor)
                    .background(Color.clear)

                if let icon = trailingIcon {
                    Button(action: { onTrailingIconClicked?() }) {
                        ComponentImage(icon)
                            .foregroundColor(trailingIconForegroundColor ?? (enabled ? TextFieldGeneralTheme.Colors.primaryTextColor : TextFieldGeneralTheme.Colors.disabledTextColor))
                    }
                    .frame(height: TextFieldGeneralTheme.Spacing.messageIconHeight)
                }
            }
            .padding(.horizontal, TextFieldGeneralTheme.Spacing.containerPadding)
        }
    }

    private func messageView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            // Display the error message, if available
            if let error = errorMessage {
                HStack {
                    if let icon = error.getIcon() {
                        ComponentImage(icon)
                            .foregroundColor(error.getColor())
                            .frame(height: TextFieldGeneralTheme.Spacing.messageIconHeight)
                    }
                    Text(error.getText())
                        .foregroundColor(error.getColor())
                        .font(TextFieldGeneralTheme.Fonts.messageFont)
                }
            }
            
            // Display the informational message, if available
            if let info = infoMessage {
                HStack {
                    if let icon = info.getIcon() {
                        ComponentImage(icon)
                            .foregroundColor(info.getColor())
                            .frame(height: TextFieldGeneralTheme.Spacing.messageIconHeight)
                    }
                    Text(info.getText())
                        .foregroundColor(info.getColor())
                        .font(TextFieldGeneralTheme.Fonts.messageFont)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
    }
}

// MARK: - ComponentImage Mock
struct ComponentImage: View {
    var name: String
    var resizable: Bool = false

    var body: some View {
        Image(systemName: name)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

// MARK: - Example Usage
struct ContentView: View {
    @State private var username: String = ""

    var body: some View {
        VStack(spacing: 24) {
            // Example 1: Default state with only informational message
            TextFieldGeneral(
                text: $username,
                label: "Username",
                placeholder: "Enter your username",
                infoMessage: .info(text: "This is a required field", icon: "info.circle")
            )
            
            // Example 2: Error state with both error and informational messages
            TextFieldGeneral(
                text: $username,
                label: "Password",
                placeholder: "Enter your password",
                errorMessage: .error(text: "Invalid password", icon: "exclamationmark.circle"),
                infoMessage: .info(text: "Password must be at least 8 characters", icon: "info.circle")
            )
        }
        .padding()
    }
}
