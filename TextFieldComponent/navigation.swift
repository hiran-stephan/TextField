struct AccountNicknameFormViewModelMapper {
    static func mapToViewModelData(
        presenter: AccountPreferencesDetailsScreenPresenter,
        accountPresenter: AccountPreferencesDetailsAccountPresenter
    ) -> AccountNicknameFormViewData {
        return AccountNicknameFormViewData(
            label: presenter.accountNicknameFieldLabelText,
            inlineMessageText: presenter.accountNicknameInlineMessageText,
            primaryButtonText: presenter.accountNicknameSaveButtonText,
            secondaryButtonText: presenter.accountNicknameCancelButtonText,
            nickname: accountPresenter.nickname ?? ""
        )
    }
}


struct ViewModelFactory {
    static func createAccountNicknameFormViewModel(
        presenter: AccountPreferencesDetailsScreenPresenter,
        accountPresenter: AccountPreferencesDetailsAccountPresenter
    ) -> AccountNicknameFormViewModel {
        let viewData = AccountNicknameFormViewModelMapper.mapToViewModelData(
            presenter: presenter,
            accountPresenter: accountPresenter
        )
        return AccountNicknameFormViewModel(viewData: viewData)
    }
}


@State private lazy var accountNicknameFormViewModel: AccountNicknameFormViewModel? = {
    if let accountPresenter = createAccountPresenter() {
        return ViewModelFactory.createAccountNicknameFormViewModel(
            presenter: viewModel.createScreenPresenter(),
            accountPresenter: accountPresenter
        )
    }
    return nil
}()


