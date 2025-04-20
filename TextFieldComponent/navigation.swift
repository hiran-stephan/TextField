private func inputState(for field: RecoverUserIdField, using presenter: RecoverUserIdFieldErrorPresenter) -> InputFieldState {
    presenter.getError(field: field) != nil ? .error : .default
}
inputFieldState: inputState(for: .fieldPhoneNumber, using: recoverUserIdFieldErrorPresenter),

