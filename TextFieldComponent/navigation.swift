import SwiftUI

extension AttributedString {
    mutating func highlightErrorCodes(highlightColor: Color, defaultColor: Color) {
        let pattern = "\\(\\d{4,}\\)" // Matches error codes like (0045)

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            self.foregroundColor = defaultColor
            return
        }

        let fullString = String(self) // Convert `AttributedString` to `String`
        let nsString = fullString as NSString
        let matches = regex.matches(in: fullString, range: NSRange(location: 0, length: nsString.length))

        for match in matches.reversed() {
            let nsRange = match.range

            guard let range = Range(nsRange, in: fullString),
                  let attributedRange = self.range(of: fullString[range]) else { continue }

            self[attributedRange].foregroundColor = highlightColor
        }

        self.foregroundColor = defaultColor
    }
}
