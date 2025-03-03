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


Hi @Chellappan Pillai Rajendran Pi, AnuRaj,

My test devices were automatically updated to the latest iOS version, and I am now unable to connect them to Xcode for development and testing.

I kindly request a replacement test device and would like to return the current ones.

Looking forward to your response. I appreciate your help!
