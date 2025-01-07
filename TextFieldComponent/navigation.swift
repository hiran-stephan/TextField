import SwiftUI

struct TextFieldGeneral: View {
    @Binding var text: String
    var enabled: Bool = true
    var label: String
    var labelIcon: String?
    var leadingIcon: String?
    var trailingIcon: String?
    var trailingIconForegroundColor: Color?
    var placeholder: String?
    var isError: Bool = false
    var errorMessage: String? // Use raw error message text
    var infoMessage: String? // Use raw info message text
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
        isError: Bool = false,
        errorMessage: String? = nil,
        infoMessage: String? = nil,
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
        self.isError = isError
        self.errorMessage = errorMessage
        self.infoMessage = infoMessage
        self.trailingIconAccessibilityLabel = trailingIconAccessibilityLabel
        self.onTrailingIconClicked = onTrailingIconClicked
        self.onQuickTipClicked = onQuickTipClicked
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Text Field and Other Content
            TextField(placeholder ?? "", text: $text)
                .disabled(!enabled)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(isError ? Color.red : Color.gray))

            // Error Message
            if let errorMessage = errorMessage, isError {
                InlineAlert(
                    statusMessage: errorMessage,
                    statusType: "error"
                )
            }

            // Info Message
            if let infoMessage = infoMessage, !isError {
                InlineAlert(
                    statusMessage: infoMessage,
                    statusType: "information"
                )
            }
        }
        .padding()
    }
}
