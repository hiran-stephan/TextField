import SwiftUI

/// A ViewModel for managing account nickname form
final class AccountNicknameFormViewModel: ObservableObject {
    
    // MARK: - Nested Types
    enum Field {
        case nickname
    }
    
    // MARK: - Published Properties
    @Published var nickname: String = "" {
        didSet {
            if oldValue != nickname {
                validateNickname()
            }
        }
    }
    
    @Published var isEditingNickname: Bool = false
    @Published var validationNickname: NicknameFormValidationResults?
    @Published var hasValidationError: Bool = false
    @Published var validationMessage: String = ""
    
    // MARK: - Methods
    
    /// Initiates editing for the given field
    func edit(field: Field) {
        isEditingNickname = (field == .nickname)
    }
    
    /// Clears the nickname field and resets validation
    func clearNickname() {
        nickname = ""
        resetValidationState()
    }
    
    // MARK: - Validation Logic
    
    /// Updates validation results for the nickname
    func updateValidation(result: NicknameFormValidationResults) -> Bool {
        guard validationNickname != result else { return result.nickname.isValid ?? false }
        
        validationNickname = result
        validationMessage = result.nickname.error?.message ?? ""
        
        if let isValid = result.nickname.isValid {
            hasValidationError = !isValid
            return isValid
        }
        
        hasValidationError = false
        return false
    }
    
    /// Validates the current nickname
    private func validateNickname() {
        let validationResult = validate(nickname: nickname)
        _ = updateValidation(result: validationResult)
    }
    
    /// Performs validation logic
    private func validate(nickname: String) -> NicknameFormValidationResults {
        if nickname.isEmpty {
            return NicknameFormValidationResults(
                nickname: NicknameValidation(
                    isValid: false,
                    error: ValidationError(message: "Nickname cannot be empty.")
                )
            )
        }
        
        // Add additional rules here, e.g., length or invalid characters
        return NicknameFormValidationResults(
            nickname: NicknameValidation(isValid: true, error: nil)
        )
    }
    
    /// Resets validation state
    private func resetValidationState() {
        validationNickname = nil
        hasValidationError = false
        validationMessage = ""
    }
}
