struct TextFieldViewModelInputFilterModifier: ViewModifier {
    @Binding var text: String
    let filter: (String) -> String
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .onChange(of: text) { newValue in
                let newFiltered = filter(newValue)
                if newValue != newFiltered {
                    text = newFiltered
                }
                action?()
            }
    }
}


extension View {
    func replaceText(
        _ text: Binding<String>,
        using filter: @escaping (String) -> String,
        action: (() -> Void)? = nil
    ) -> some View {
        modifier(TextFieldViewModelInputFilterModifier(text: text, filter: filter, action: action))
    }
}

    .replaceText($phoneNumber, using: viewModel.filterPhoneNumber(number:), action: {
        viewModel.onChangePhoneNumber(phoneNumber: phoneNumber)
    })


