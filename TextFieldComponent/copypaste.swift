fun String.formatDecimalPart(): String {
    val parts = this.split(".")

    val decimalPart = if (parts.size > 1) {
        val cents = parts[1].padEnd(2, '0').take(2)
        ".$cents"
    } else {
        ".00"
    }

    return parts[0] + decimalPart
}


@FocusState private var isAmountFieldFocused: Bool

TextFieldAmount(
    model: TextFieldAmount.Model(
        label: alertSettingsFormPresenter.alertInputLabel,
        placeholder: "$"
    ),
    text: $amount,
    ...
)
.focused($isAmountFieldFocused) // 👈 Track focus here
.replaceText(
    $amount,
    with: { text in
        viewModel.validateAmountField(text: text, isEditing: true) // filtering while editing
    },
    action: {
        viewModel.onAlertInputFieldValueChanged(amount: amount)
    }
)
.onChange(of: isAmountFieldFocused) { isFocused in
    if !isFocused {
        // Editing ended → Apply final formatting
        amount = viewModel.validateAmountField(text: amount, isEditing: false)
    }
}

