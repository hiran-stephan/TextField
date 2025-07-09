private struct AmountTextFieldView: View {
    let model: TextFieldAmount.Model
    @Binding var text: String
    let placeholder: String?
    var tooltip: () -> ToolTipButton?

    var body: some View {
        TextFieldView(
            style: AmountTextFieldStyle(),
            text: Binding(
                get: {
                    if let doubleValue = Double(text) {
                        return CurrencyFormatter.shared.string(from: NSNumber(value: doubleValue)) ?? "$0.00"
                    } else {
                        return "$0.00"
                    }
                },
                set: { newValue in
                    let raw = newValue.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)

                    if let dotIndex = raw.firstIndex(of: ".") {
                        let intPart = raw[..<dotIndex]
                        let decimalPart = raw[raw.index(after: dotIndex)...].prefix(2)
                        text = "\(intPart).\(decimalPart)"
                    } else {
                        text = raw
                    }
                }
            ),
            placeholder: placeholder,
            titleView: {
                TextFieldTitleView(model.label, tooltip: tooltip())
            }
        )
        .keyboardType(.decimalPad)
    }
}


enum CurrencyFormatter {
    static let shared: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_CA") // adjust if needed
        return formatter
    }()
}

@State private var thresholdText: String = "0.00"

AmountTextFieldView(
    model: .currency,
    text: $thresholdText,
    placeholder: "$",
    tooltip: { nil }
)

