private func createAttributedString() -> AttributedString {
        var attributedString = AttributedString(statusMessage)
        
        if let errorCode = errorCode, !errorCode.isEmpty {
            var errorAttributedString = AttributedString(" \(errorCode)")
            errorAttributedString.foregroundColor = errorColor
            attributedString += errorAttributedString
        }

        return attributedString
    }
