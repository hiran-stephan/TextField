/// Displays the view for editing the account nickname.
/// - Returns: A view representing the edit nickname screen.
@ViewBuilder
private func editNicknameView() -> some View {
    if let accountNicknameFormViewModel = self.accountNicknameFormViewModel {
        AccountNicknameFormView(
            viewModel: accountNicknameFormViewModel,
            isEditingNickname: Binding(
                get: { isEditingNickname },
                set: { newValue in
                    viewModel.onEditingNickname(isEditingNickname: newValue)
                }
            ),
            onSave: handleSaveNickname
        )
    }
}


/// Displays the view for showing the account nickname.
/// - Returns: A view representing the display nickname screen.
@ViewBuilder
private func displayNicknameView() -> some View {
    let presenter = viewModel.createScreenPresenter()
    if let accountPresenter = createAccountPresenter() {
        AccountNicknameView(
            label: presenter.accountNicknameText,
            hasNickname: accountPresenter.hasNickname,
            nickname: accountPresenter.nickname ?? "",
            buttonText: presenter.accountNicknameAddNicknameButtonText,
            onButtonTap: handleAddNickname
        )
    }
}


/// Handles the save action for the account nickname.
private func handleSaveNickname() {
    let presenter = viewModel.createScreenPresenter()

    // Validate nickname
    let validationResult = viewModel.validateForm(
        nickname: nickname,
        charLimit: nicknameCharLimit,
        message: presenter.accountNicknameInlineMessageText
    )

    // Perform save if valid
    if let id = model.state?.accountPreferencesAccountDetails?.id {
        if let result = accountNicknameFormViewModel?.updateValidation(result: validationResult, resultText: nickname) {
            viewModel.updateAccountNickname(
                accountId: id,
                nickname: nickname
            )
        }
    }
}



/// Handles the add nickname action.
private func handleAddNickname() {
    accountNicknameFormViewModel = createAccountNicknameFormViewModel()
    viewModel.onEditingNickname(isEditingNickname: true)
}



/// Checks the status of account preferences update completion.
/// - Returns: A boolean indicating whether the account preferences update is complete.
func checkAccountPreferencesUpdateCompleteStatus() -> Bool {
    DispatchQueue.main.async {
        if accountPreferencesUpdateComplete {
            viewModel.onEditingNickname(isEditingNickname: false)
            accountNicknameFormViewModel?.clearNickname()
        }
    }
    return accountPreferencesUpdateComplete
}


/// Creates a view model for the account nickname form.
/// - Returns: An optional `AccountNicknameFormViewModel` instance.
func createAccountNicknameFormViewModel() -> AccountNicknameFormViewModel? {
    if let accountPresenter = createAccountPresenter() {
        let viewData = AccountNicknameFormViewModelMapper.mapToAccountNicknameFormViewData(
            presenter: viewModel.createScreenPresenter(),
            accountPresenter: accountPresenter
        )
        return AccountNicknameFormViewModel(viewData: viewData)
    }
    return nil
}


/// Creates an instance of `AccountPreferencesDetailsAccountPresenter` if available.
/// - Returns: An optional `AccountPreferencesDetailsAccountPresenter` instance.
private func createAccountPresenter() -> AccountPreferencesDetailsAccountPresenter? {
    guard let account = model.state?.accountPreferencesAccountDetails else {
        return nil
    }
    return viewModel.createAccountPresenter(account: account)
}


