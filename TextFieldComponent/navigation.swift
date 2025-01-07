struct AccountNicknameFormViewModelMapper {
    static func mapToViewModel(
        presenter: ScreenPresenter,
        accountPresenter: AccountPresenter,
        onPrimaryButtonTap: @escaping () -> Void,
        onSecondaryButtonTap: @escaping () -> Void
    ) -> AccountNicknameFormViewModel {
        let viewData = AccountNicknameFormViewData(
            label: presenter.accountNicknameFieldLabelText,
            inlineMessageText: presenter.accountNicknameInlineMessageText,
            primaryButtonText: presenter.accountNicknameSaveButtonText,
            secondaryButtonText: presenter.accountNicknameCancelButtonText,
            nickname: accountPresenter.nickname ?? ""
        )
        return AccountNicknameFormViewModel(
            viewData: viewData,
            onPrimaryButtonTap: onPrimaryButtonTap,
            onSecondaryButtonTap: onSecondaryButtonTap
        )
    }
}
