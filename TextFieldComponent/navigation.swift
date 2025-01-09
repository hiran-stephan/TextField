@ViewBuilder
private func editNicknameView() -> some View {
    if let accountNicknameFormViewModel = self.accountNicknameFormViewModel,
       let state = self.model.state {
        AccountNicknameFormView(
            formViewModel: accountNicknameFormViewModel,
            isEditingNickname: Binding(
                get: { state.isEditingNickname },
                set: { newValue in
                    model.state?.isEditingNickname = newValue
                }
            )
        ) {
            // Save button action
            handleSaveNickname()
        }
    }
}
