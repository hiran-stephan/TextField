final class AccountNicknameFormViewModel: ObservableObject {
    enum Field {
        case nickname
    }

    @Published var nickname: String = "" {
        didSet {
            if nickname != oldValue {
                validateNickname()
            }
        }
    }
    @Published var editingNickname = false
    @Published var validationNickname: ValidationRule?

    func edit(field: Field) {
        editingNickname = field == .nickname
    }

    private func validateNickname() {
        let maxLengthRule = MaxLength(maximum: 20, message: "Nickname cannot exceed 20 characters.") // Adjust maximum as needed
        if !maxLengthRule.isValid(nickname) {
            validationNickname = maxLengthRule
        } else {
            validationNickname = nil
        }
    }
}

sealed class MaxLength(
    private val maximum: Int,
    override val message: String
) : ValidationRule(id = VALIDATE_LENGTH_MAX) {
    override fun <T> isValid(item: T?): Boolean {
        return (item as? CharSequence)?.length ?: 0 <= maximum
    }
}


