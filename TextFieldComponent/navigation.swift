import SwiftUI

extension String {
    func attributedWithErrorCode(highlightColor: UIColor, defaultColor: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self, attributes: [
            .foregroundColor: defaultColor
        ])
        
        let pattern = "\\(\\d{4,}\\)"  // Matches error codes like (0045)

        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))

            for match in matches {
                attributedString.addAttribute(.foregroundColor, value: highlightColor, range: match.range)
            }
        }

        return attributedString
    }
}






public struct InlineAlert: View {
    let statusMessage: AttributedString
    let alertType: AlertType
    let mode: Mode
    
    public init(statusMessage: String, alertType: AlertType, mode: Mode = .bordered) {
        self.statusMessage = statusMessage.attributedWithErrorCode(
            highlightColor: BankingTheme.colors.error,  // Custom color for the error code
            defaultColor: BankingTheme.colors.textPrimary // Default text color
        )
        self.alertType = alertType
        self.mode = mode
    }

    public var body: some View {
        switch mode {
        case .bordered:
            borderedView()
        case .borderless(let hasIcon):
            borderLessView(hasIcon)
        }
    }
}



@ViewBuilder
private func errorAlertView(message: String) -> some View {
    HStack(alignment: .top, spacing: BankingTheme.dimens.microSmall) {
        InlineAlert(
            statusMessage: message,
            alertType: .error,
            mode: .borderless(hasIcon: true)
        )
    }
    .padding(.top, BankingTheme.dimens.small)
    .frame(maxWidth: .infinity, alignment: .topLeading)
}
