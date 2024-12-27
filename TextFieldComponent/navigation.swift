extension AccountPreferencesDetailsScreen {
    @State private var isEditingNickname: Bool = false

    /// Account Nickname Section
    ///
    /// Displays the account nickname section, toggling between the nickname view and the form view.
    private func accountNicknameSection() -> some View {
        let presenter = viewModel.createScreenPresenter()

        return Group {
            if isEditingNickname {
                AccountNicknameFormView(
                    label: presenter.accountNicknameText,
                    buttonText: presenter.accountNicknameAddNicknameButtonText,
                    inlineMessageText: presenter.accountNicknameInlineMessageText,
                    primaryButtonText: presenter.accountNicknameSaveButtonText,
                    secondaryButtonText: presenter.accountNicknameCancelButtonText,
                    onTextFieldCloseButtonTap: {
                        // Handle text field close button tap
                    },
                    onPrimaryButtonTap: {
                        // Handle save action
                        print("Nickname saved")
                        isEditingNickname = false // Go back to the nickname view
                    },
                    onSecondaryButtonTap: {
                        // Handle cancel action
                        isEditingNickname = false // Go back to the nickname view
                    }
                )
            } else {
                AccountNicknameView(
                    label: presenter.accountNicknameText,
                    buttonText: presenter.accountNicknameAddNicknameButtonText
                ) {
                    // Perform action when the button is tapped
                    print("Nickname button tapped")
                    isEditingNickname = true // Show the form view
                }
            }
        }
    }
}
