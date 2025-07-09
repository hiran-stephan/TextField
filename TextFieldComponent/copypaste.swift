private struct AmountTextFieldView: View {
    let model: TextFieldAmount.Model
    @Binding var text: String
    let placeholder: String?
    var tooltip: () -> ToolTipButton?

    @State private var isEditing: Bool = false

    var body: some View {
        TextFieldView(
            style: AmountTextFieldStyle(),
            text: Binding(
                get: {
                    if let doubleValue = Double(text) {
                        if isEditing {
                            return CurrencyFormatter.liveEditing.string(from: NSNumber(value: doubleValue)) ?? "$"
                        } else {
                            return CurrencyFormatter.finalized.string(from: NSNumber(value: doubleValue)) ?? "$0.00"
                        }
                    }
                    return "$"
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
            },
            onEditingChanged: { editing in
                isEditing = editing
                if !editing {
                    // Final formatting on blur
                    if let doubleValue = Double(text) {
                        text = String(format: "%.2f", doubleValue)
                    }
                }
            }
        )
        .keyboardType(.decimalPad)
    }
}

enum CurrencyFormatter {
    static let liveEditing: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 0
        formatter.currencySymbol = "$"
        formatter.positivePrefix = "$"
        return formatter
    }()

    static let finalized: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

