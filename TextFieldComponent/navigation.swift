private func createAttributedString(
    message: String,
    errorCode: String?,
    messageColor: Color,
    errorColor: Color
) -> AttributedString {
    var attributedString = AttributedString(message)
    attributedString.foregroundColor = messageColor  // Apply color inline

    guard let errorCode, !errorCode.isEmpty else { return attributedString }

    var errorAttributedString = AttributedString(" \(errorCode)")
    errorAttributedString.foregroundColor = errorColor  // Apply color inline

    attributedString.append(errorAttributedString)  // Append error code
    return attributedString
}
