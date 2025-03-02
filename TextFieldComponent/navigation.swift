
import SwiftUI

import SwiftUI

extension String {
    func attributedWithErrorCode(highlightColor: Color, defaultColor: Color) -> AttributedString {
        var attributedString = AttributedString(self)
        let pattern = "\\(\\d{4,}\\)"  // Matches error codes like (0045)

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            attributedString.foregroundColor = defaultColor
            return attributedString
        }

        let nsString = self as NSString
        let matches = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))

        for match in matches.reversed() { // Process in reverse to avoid index shifting
            let nsRange = match.range
            
            guard let range = Range(nsRange, in: self),
                  let attributedRange = attributedString.range(of: self[range]) else { continue }

            attributedString[attributedRange].foregroundColor = highlightColor
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
