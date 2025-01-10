/// The view model managing the account preferences details screen.
@State private var viewModel: AccountPreferencesDetailsViewModel

/// Observed object to handle state updates for resource and UI states.
@ObservedObject private var model: ObservableModelState<AccountPreferencesDetailsResourceUiState, AccountPreferencesDetailsUiState>

/// Observed object to handle state updates for actions.
@ObservedObject private var actionModel: ObservableState<AccountPreferencesDetailsActionState>

/// The view model for managing the account nickname form.
@State private var accountNicknameFormViewModel: AccountNicknameFormViewModel? = nil

/// Indicates whether a toggle is switched on or off. (To be moved to KMP)
@State var isToggled: Bool = false

/// Indicates whether the user is currently editing the account nickname.
private var isEditingNickname: Bool {
    model.state?.isEditingNickname ?? false
}

/// Determines if the trailing icon in the header should be shown.
private var showHeaderTrailingIcon: Bool {
    createAccountPresenter()?.hasNickname ?? false
}

/// Indicates whether the account preferences update is complete.
private var accountPreferencesUpdateComplete: Bool {
    self.actionModel.state?.accountPreferencesUpdateComplete ?? false
}

/// The nickname entered by the user.
private var nickname: String {
    accountNicknameFormViewModel?.viewData.nickname ?? ""
}

/// The maximum character limit for the nickname.
let nicknameCharLimit: Int32 = 20

