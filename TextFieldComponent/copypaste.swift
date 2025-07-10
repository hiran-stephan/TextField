TextFieldAmount(
    model: ...,
    text: $amount
)
.focused($isAmountFieldFocused)
.replaceText(
    $amount,
    with: { viewModel.validateAmountField(text: $0, isEditing: true) },
    action: { viewModel.onAlertInputFieldValueChanged(amount: amount) }
)
.formatOnFocusChange(
    text: $amount,
    isFocused: $isAmountFieldFocused,
    format: { viewModel.validateAmountField(text: $0, isEditing: false) }
)


import SwiftUI

private struct FormatOnFocusChangeModifier: ViewModifier {
    @Binding var text: String
    let isFocused: FocusState<Bool>.Binding
    let format: (String) -> String

    func body(content: Content) -> some View {
        content
            .onChange(of: isFocused.wrappedValue) { focused in
                if !focused {
                    let newValue = format(text)
                    if newValue != text {
                        text = newValue
                    }
                }
            }
    }
}

public extension View {
    func formatOnFocusChange(
        text: Binding<String>,
        isFocused: FocusState<Bool>.Binding,
        format: @escaping (String) -> String
    ) -> some View {
        self.modifier(
            FormatOnFocusChangeModifier(
                text: text,
                isFocused: isFocused,
                format: format
            )
        )
    }
}
