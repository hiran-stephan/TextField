import SwiftUI

private struct FormatOnSubmitModifier: ViewModifier {
    @Binding var text: String
    let format: (String) -> String

    func body(content: Content) -> some View {
        content
            .onSubmit {
                let newValue = format(text)
                if newValue != text {
                    text = newValue
                }
            }
    }
}

public extension View {
    func formatOnSubmit(
        _ text: Binding<String>,
        using format: @escaping (String) -> String
    ) -> some View {
        self.modifier(FormatOnSubmitModifier(text: text, format: format))
    }
}

    .formatOnSubmit($amount) {
        viewModel.validateAmountField(text: $0, isEditing: false)
    }
