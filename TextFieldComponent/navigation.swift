/// View model for managing the account nickname form.
final class AccountNicknameFormViewModel: ObservableObject {
    @Published private(set) var viewData: AccountNicknameFormViewData
    @Published var hasValidationError: Bool = false
    @Published var validationMessage: String = ""
    
    /// Initializes the view model with the given view data.
    /// - Parameter viewData: The initial data for the account nickname form.
    init(viewData: AccountNicknameFormViewData) {
        self.viewData = viewData
    }
    
    /// Updates the validation state based on the validation result.
    /// - Parameter result: The result of the nickname validation.
    /// - Returns: A boolean indicating whether the nickname is valid.
    func updateValidation(result: NicknameFormValidationResults) -> Bool {
        validationMessage = result.nickname.error?.message ?? ""
        hasValidationError = !result.nickname.isValid
        return result.nickname.isValid
    }
    
    /// Updates the nickname in the view data.
    /// - Parameter nickname: The new nickname to update.
    func updateNickname(_ nickname: String) {
        viewData.nickname = nickname
    }
    
    /// Clears the nickname and resets the validation state.
    func clearNickname() {
        viewData.nickname = ""
        resetValidationState()
    }
    
    /// Resets the validation state to its default values.
    private func resetValidationState() {
        hasValidationError = false
        validationMessage = ""
    }
}



/// A form view for managing account nicknames.
struct AccountNicknameFormView: View {
    @ObservedObject var formViewModel: AccountNicknameFormViewModel
    @Binding var isEditingNickname: Bool
    var onPrimaryButtonTap: () -> Void
    
    var body: some View {
        formSection()
        buttonSection()
    }
    
    /// Builds the form section with the text field and inline message.
    /// - Returns: A view representing the form section.
    private func formSection() -> some View {
        HStack(alignment: .top, spacing: BankingTheme.dimens.mediumLarge) {
            VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
                // TextField with trailing icon
                HStack(spacing: BankingTheme.spacing.noPadding) {
                    TextFieldGeneral(
                        text: Binding(
                            get: { formViewModel.viewData.nickname },
                            set: formViewModel.updateNickname
                        ),
                        label: formViewModel.viewData.label,
                        trailingIcon: BankingTheme.icons.functional.close.rawValue,
                        trailingIconForegroundColor: BankingTheme.colors.textPrimary,
                        isError: formViewModel.hasValidationError,
                        errorMessage: "Please enter a valid nickname.", // TODO: Replace with localized message.
                        content: { isAvailable in
                            InfoInlineAlertMode.borderless(hasIcon: false)
                        },
                        onTrailingIconClicked: { formViewModel.clearNickname() }
                    )
                }
                .padding(.horizontal, BankingTheme.dimens.microSmall)
            }
            .padding(.vertical, BankingTheme.dimens.mediumLarge)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(BankingTheme.colors.illustrationGrey)
            .cornerRadius(BankingTheme.dimens.smallMedium)
        }
    }
    
    /// Builds the button section with primary and secondary buttons.
    /// - Returns: A view representing the button section.
    @ViewBuilder
    private func buttonSection() -> some View {
        ActionBar(
            primaryButton: PrimaryButton(
                content: {
                    Text(formViewModel.viewData.primaryButtonText)
                },
                buttonPaddingHorizontal: .zero,
                onPrimaryButtonTap
            ),
            secondaryButton: SecondaryButton(
                content: {
                    Text(formViewModel.viewData.secondaryButtonText)
                },
                buttonPaddingHorizontal: .zero,
                handleCancelNicknameEdit
            )
        )
        .padding(.top, BankingTheme.dimens.extraLarge)
    }
    
    /// Handles the cancel action for editing a nickname.
    private func handleCancelNicknameEdit() {
        isEditingNickname = false
        formViewModel.clearNickname()
    }
}
