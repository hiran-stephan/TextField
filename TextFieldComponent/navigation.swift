
import SwiftUI

extension String {
    func attributedWithErrorCode(highlightColor: Color, defaultColor: Color) -> AttributedString {
        var attributedString = AttributedString(self)
        let pattern = "\\(\\d{4,}\\)"  // Matches error codes like (0045)

        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let nsString = self as NSString
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))

            for match in matches {
                let nsRange = match.range

                // Convert NSRange to AttributedString.Index
                if let lowerBound = attributedString.index(AttributedString.Index(utf16Offset: nsRange.location, in: attributedString)),
                   let upperBound = attributedString.index(lowerBound, offsetBy: nsRange.length, limitedBy: attributedString.endIndex) {
                    
                    let attributedRange = lowerBound..<upperBound
                    attributedString[attributedRange].foregroundColor = highlightColor
                }
            }
        }

        attributedString.foregroundColor = defaultColor
        return attributedString
    }
}



extension InlineAlert {
    func errorCodeColor(_ color: Color, defaultColor: Color = BankingTheme.colors.textPrimary) -> InlineAlert {
        return InlineAlert(
            statusMessage: self.statusMessage.attributedWithErrorCode(
                highlightColor: color,
                defaultColor: defaultColor
            ),
            alertType: self.alertType,
            mode: self.mode
        )
    }
}

struct ContentView: View {
    var body: some View {
        InlineAlert(
            statusMessage: "An error occurred. Please try again. (0045)",
            alertType: .error
        )
        .errorCodeColor(.red, defaultColor: .black) // Highlights (0045) in red, rest in black
        .padding()
    }
}
