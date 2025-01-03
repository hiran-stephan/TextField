final class AccountNicknameFormViewModel: ObservableObject {
    // Shared ViewModel from the KMP module
    let sharedViewModel: SharedViewModel

    @Published var nickname: String = "" {
        didSet {
            if nickname != oldValue {
                validationNickname = nil
            }
        }
    }

    @Published var validationNickname: ValidationResult?
    @Published var isNicknameValid: Bool = true

    init(sharedViewModel: SharedViewModel) {
        self.sharedViewModel = sharedViewModel
    }

    func submitForm() {
        let validationResult = sharedViewModel.validateForm(nickname: nickname)
        updateValidation(result: validationResult.nickname)
    }

    private func updateValidation(result: ValidationResult) {
        if !result.isValid {
            validationNickname = result
            isNicknameValid = false
        } else {
            validationNickname = nil
            isNicknameValid = true
        }
    }
}
