private func createAttributedString(statusMessage: AttributedString, errorCode: String?) -> AttributedString {
    var mutableStatusMessage = statusMessage // Create a mutable copy

    if let errorCode = errorCode, !errorCode.isEmpty {
        var errorAttributedString = AttributedString(" \(errorCode)")
        errorAttributedString.setAttributes([.foregroundColor: BankingTheme.colors.textSecondary])
        mutableStatusMessage.append(errorAttributedString) // Append to mutable copy
    }

    return mutableStatusMessage // Return the modified version
}
