import SwiftUI

extension String {
    func attributedWithErrorCode(highlightColor: Color, defaultColor: Color) -> AttributedString {
        var attributedString = AttributedString(self)
        
        let pattern = "\\(\\d{4,}\\)"  // Matches error codes like (0045)
        
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let nsString = self as NSString
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))
            
            for match in matches {
                if let range = Range(match.range, in: self) {
                    attributedString[range].foregroundColor = highlightColor
                }
            }
        }
        
        attributedString.foregroundColor = defaultColor
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
