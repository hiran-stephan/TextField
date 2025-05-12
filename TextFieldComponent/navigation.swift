class ChangeUserIdValidationPresenter(
    private val userId: String,
    private val contentFile: ContentFileMasthead? = null,
    private val locale: Locale
) {

    private val validationRules: List<ValidationRule> = listOf(
        ValidationRule.MinMaxLength(
            minimum = USERID_MIN_LENGTH,
            maximum = USERID_MAX_LENGTH,
            message = VALIDATION_MESSAGE_LENGTH,
        ),
        ValidationRule.AtLeastTwoCharactersAndTwoNumbersRule(
            message = VALIDATION_MESSAGE_CHAR_AND_NUM,
        ),
        ValidationRule.NoAllowedUsernameCharactersRule(
            message = VALIDATION_MESSAGE_INVALID_CHARS,
        )
    )

    fun getValidationResults(): List<ValidationResult> {
        val trimmedUserId = userId.trim()

        return validationRules.map { rule ->
            val status = when {
                trimmedUserId.isEmpty() -> ValidationStatus.INITIAL
                rule.isValid(trimmedUserId) == true -> ValidationStatus.VALID
                else -> ValidationStatus.INVALID
            }

            ValidationResult(
                ruleId = rule.id,
                status = status,
                message = rule.message,
                accessibilityText = getAccessibilityTextFor(status)
            )
        }
    }

    private fun getAccessibilityTextFor(status: ValidationStatus): String {
        val key = when (status) {
            ValidationStatus.VALID -> "rule_met"
            ValidationStatus.INVALID -> "rule_not_met"
            ValidationStatus.INITIAL -> "rule_not_yet_met"
        }
        return contentFile?.findContentValue(key, locale.lang, forAccessibility = true) ?: ""
    }
}


import Foundation

extension CriteriaCheckStatus {
    init(from status: ValidationStatus) {
        switch status {
        case .valid: self = .valid
        case .invalid: self = .invalid
        case .unknown: self = .unknown
        }
    }
}

func mapToCriteriaCheckModels(from results: [ValidationResult]) -> [CriteriaCheckModel] {
    return results.map {
        CriteriaCheckModel(
            id: it.ruleId,
            message: it.message,
            status: CriteriaCheckStatus(from: it.status),
            accessibilityText: it.accessibilityText
        )
    }
}


StandardCheckView(
    checks: mapToCriteriaCheckModels(from: presenter.getValidationResults()),
    passwordStrength: nil, // or your PasswordStrengthModel
    accessibilityText: "Your user ID must have:"
)

public struct CriteriaCheckModel: Identifiable {
    public let id: Int
    public let message: String
    public let status: CriteriaCheckStatus
    public let accessibilityText: String

    public init(id: Int, message: String, status: CriteriaCheckStatus, accessibilityText: String) {
        self.id = id
        self.message = message
        self.status = status
        self.accessibilityText = accessibilityText
    }
}
