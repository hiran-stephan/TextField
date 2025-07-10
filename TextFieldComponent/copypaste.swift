.replaceText(
    $amount,
    with: { text in
        viewModel.validateAmountField(text: text, isEditing: true)
    },
    action: {
        viewModel.onAlertInputFieldValueChanged(amount: amount)
    }
)
