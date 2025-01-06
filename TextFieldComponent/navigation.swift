/// Creates an instance of `AccountPreferencesDetailsAccountPresenter` if available
///
/// - Returns: An optional `AccountPreferencesDetailsAccountPresenter`
private func createAccountPresenter() -> AccountPreferencesDetailsAccountPresenter? {
    guard let account = model?.state?.accountPreferencesAccountDetails else {
        return nil
    }
    return viewModel.createAccountPresenter(account: account)
}
