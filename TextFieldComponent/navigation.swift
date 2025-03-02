@ViewBuilder
private func errorAlertView(message: String, code: String?) -> some View {
    var attributedString = AttributedString(message)
    let errorCode = code ?? ""

    // Apply color attributes
    if let messageRange = attributedString.range(of: message) {
        attributedString[messageRange].foregroundColor = .primary // Change to your desired color
    }
    
    if !errorCode.isEmpty {
        var errorAttributedString = AttributedString(" " + errorCode)
        errorAttributedString.foregroundColor = .red // Change to your desired error color
        
        attributedString.append(errorAttributedString)
    }

    HStack(alignment: .top, spacing: BankingTheme.dimens.microSmall) {
        InlineAlert(
            statusMessage: attributedString,
            alertType: .error,
            mode: .borderless(hasIcon: true)
        )
    }
    .padding(.top, BankingTheme.dimens.small)
    .frame(maxWidth: .infinity, alignment: .topLeading)
}
