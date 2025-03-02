extension String {
    func attributedWithErrorCode(highlightColor: Color, defaultColor: Color) -> AttributedString {
        var attributedString = AttributedString(self)
        let pattern = "\\(\\d{4,}\\)"  // Matches error codes like (0045)

        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let nsString = self as NSString
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))

            for match in matches {
                let nsRange = match.range
                
                if let lowerBound = attributedString.index(AttributedString.Index(utf16Offset: nsRange.location, in: attributedString), offsetBy: 0, limitedBy: attributedString.endIndex),
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
