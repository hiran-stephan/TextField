let nickname = viewModel.createAccountPresenter()?.nickname ?? ""
        _accountNicknameFormViewModel = StateObject(wrappedValue: AccountNicknameFormViewModel(nickname: nickname))
    
