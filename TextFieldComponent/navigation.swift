private func createAttributedString() -> AttributedString {
    var attributedString = AttributedString(statusMessage)
    
    if let errorCode = errorCode, !errorCode.isEmpty {
        var errorAttributedString = AttributedString(" \(errorCode)")
        errorAttributedString.setAttributes(.init([.foregroundColor: errorColor])) // Set color correctly
        attributedString.append(errorAttributedString) // Append to main message
    }

    return attributedString
}
