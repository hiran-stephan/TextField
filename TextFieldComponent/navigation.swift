extension AccountPreferencesDetailsScreen {
    
    // MARK: - Account Nickname Section
    @ViewBuilder
    private func accountNicknameSection() -> some View {
        if isEditingNickname {
            editNicknameView()
        } else {
            displayNicknameView()
        }
    }
    
    @ViewBuilder
    private func editNicknameView() -> some View {
        AccountNicknameFormView(
            formViewModel: accountNicknameFormViewModel,
            label: presenter.accountNicknameFieldLabelText,
            inlineMessageText: presenter.accountNicknameInlineMessageText,
            isValidationError: accountNicknameFormViewModel.hasValidationError.wrappedValue,
            primaryButtonText: presenter.accountNicknameSaveButtonText,
            secondaryButtonText: presenter.accountNicknameCancelButtonText,
            textFieldCloseButtonTap: {
                accountNicknameFormViewModel.clearNickname()
            },
            onPrimaryButtonTap: {
                handleSaveNickname()
            },
            onSecondaryButtonTap: {
                handleCancelNicknameEdit()
            }
        )
    }
    
    @ViewBuilder
    private func displayNicknameView() -> some View {
        if let account = self.model?.state?.accountPreferencesAccountDetails {
            let accountPresenter = viewModel.createAccountPresenter(account: account)
            AccountNicknameView(
                label: presenter.accountNicknameText,
                hasNickname: accountPresenter.hasNickname,
                nickname: accountPresenter.nickname,
                buttonText: presenter.accountNicknameAddNicknameButtonText,
                onButtonTap: {
                    handleAddNickname()
                }
            )
        }
    }
    
    // MARK: - Actions
    private func handleSaveNickname() {
        // Validate nickname
        let validationResult = viewModel.validateForm(
            nickname: accountNicknameFormViewModel.nickname,
            charLimit: 20,
            message: presenter.accountNicknameInlineMessageText
        )
        
        // Perform save if valid
        if let id = model?.state?.accountDetails?.id {
            accountNicknameFormViewModel.updateValidation(result: validationResult)
            viewModel.updateAccountNickname(
                accountId: id,
                nickname: accountNicknameFormViewModel.nickname
            )
        }
    }
    
    private func handleCancelNicknameEdit() {
        isEditingNickname = false
        accountNicknameFormViewModel.clearNickname()
    }
    
    private func handleAddNickname() {
        print("Add Nickname button tapped")
        isEditingNickname = true
    }
}
