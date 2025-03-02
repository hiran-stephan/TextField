import SwiftUI

extension AttributedString {
    func withHighlightedErrorCodes(highlightColor: Color, defaultColor: Color) -> AttributedString {
        var newAttributedString = self
        let pattern = "\\(\\d{4,}\\)" // Matches error codes like (0045)

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            newAttributedString.foregroundColor = defaultColor
            return newAttributedString
        }

        let fullString = String(self) // Convert `AttributedString` to `String`
        let nsString = fullString as NSString
        let matches = regex.matches(in: fullString, range: NSRange(location: 0, length: nsString.length))

        for match in matches.reversed() {
            let nsRange = match.range

            guard let range = Range(nsRange, in: fullString),
                  let attributedRange = newAttributedString.range(of: fullString[range]) else { continue }

            newAttributedString[attributedRange].foregroundColor = highlightColor
        }

        newAttributedString.foregroundColor = defaultColor
        return newAttributedString
    }
}
