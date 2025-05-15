package com.cibc.services.utilities.forms.validation

class InputValidationEngine(
    private val rules: List<ValidationRule>
) {

    fun validate(input: String): List<ValidationResult> {
        val trimmed = input.trim()
        return rules.map { rule ->
            val status = when {
                trimmed.isEmpty() -> ValidationStatus.UNKNOWN
                rule.isValid(trimmed) -> ValidationStatus.VALID
                else -> ValidationStatus.INVALID
            }

            ValidationResult(
                ruleId = rule.id,
                status = status
            )
        }
    }

    fun strength(input: String): Strength = when {
        input.isBlank() -> Strength.Blank
        !isAccepted(input) -> Strength.NotAccepted
        isStrongPassword(input) -> Strength.Strong
        isModeratePassword(input) -> Strength.Moderate
        else -> Strength.NotAccepted
    }

    private fun isAccepted(input: String): Boolean =
        rules.all { it.isValid(input) == true }

    private fun isModeratePassword(input: String): Boolean =
        isAccepted(input) && input.length < MIN_LENGTH_STRONG_PASSWORD

    private fun isStrongPassword(input: String): Boolean =
        isAccepted(input) &&
            (ValidationRule.StrongPasswordRule().isValid(input) == true ||
             input.length >= MIN_LENGTH_STRONG_PASSWORD)

    companion object {
        const val MIN_LENGTH_STRONG_PASSWORD = 17
    }
}


data class ValidationResult(
    val ruleId: Int,
    val status: ValidationStatus
)

enum class Strength(val message: String) {
    Strong("strong"),
    Moderate("Moderate"),
    NotAccepted("Not accepted"),
    Blank("")
}


package com.cibc.changeuserid.ui.screens.changeuserid.presenters

import com.cibc.services.remoteresource.data.models.ContentFileMasthead
import com.cibc.services.utilities.forms.validation.*
import java.util.Locale

class ChangeUserIdValidationPresenter(
    private val userId: String = "",
    private val contentFile: ContentFileMasthead? = null,
    private val locale: Locale
) {

    private val validationRules = listOf(
        ValidationRule.MinMaxLength(
            minimum = USER_ID_MIN_LENGTH,
            maximum = USER_ID_MAX_LENGTH,
            message = VALIDATION_MESSAGE_LENGTH
        ),
        ValidationRule.AtLeastTwoCharactersAndTwoNumbersRule(
            message = VALIDATION_MESSAGE_CHAR_NUM
        ),
        ValidationRule.NoAllowedUsernameCharactersRule(
            message = VALIDATION_MESSAGE_INVALID_CHARS
        )
    )

    private val validationEngine = InputValidationEngine(validationRules)

    val validationResults: List<ValidationResult>
        get() = validationEngine.validate(userId)

    val strength: Strength
        get() = validationEngine.strength(userId) // Optional: for consistency

    val userIdCriteria: List<UserIdValidationResult>
        get() = validationResults.map { result ->
            val rule = validationRules.find { it.id == result.ruleId }!!
            UserIdValidationResult(
                ruleId = result.ruleId,
                status = result.status,
                message = displayContent(rule.message),
                accessibilityText = getAccessibilityTextFor(result.status)
            )
        }

    private fun displayContent(key: String, forAccessibility: Boolean = false): String {
        return contentFile?.findContentValue(key, locale.language, forAccessibility).orEmpty()
    }

    private fun getAccessibilityTextFor(status: ValidationStatus): String {
        val key = when (status) {
            ValidationStatus.VALID -> CHANGE_USERID_GREEN_CHECK_ACCESSIBILITY_TEXT
            ValidationStatus.INVALID -> CHANGE_USERID_RED_CHECK_ACCESSIBILITY_TEXT
            ValidationStatus.UNKNOWN -> CHANGE_USERID_NEW_USERID_DOT_ACCESSIBILITY_TEXT
        }
        return displayContent(key, forAccessibility = true)
    }

    companion object {
        const val USER_ID_MIN_LENGTH = 6
        const val USER_ID_MAX_LENGTH = 18

        const val VALIDATION_MESSAGE_LENGTH = "change_userid_validation_length"
        const val VALIDATION_MESSAGE_CHAR_NUM = "change_userid_validation_char_num"
        const val VALIDATION_MESSAGE_INVALID_CHARS = "change_userid_validation_invalid_chars"

        const val CHANGE_USERID_GREEN_CHECK_ACCESSIBILITY_TEXT = "change_userid_accessibility_valid"
        const val CHANGE_USERID_RED_CHECK_ACCESSIBILITY_TEXT = "change_userid_accessibility_invalid"
        const val CHANGE_USERID_NEW_USERID_DOT_ACCESSIBILITY_TEXT = "change_userid_accessibility_dot"
    }
}


let dummyStrength = StrengthModel(label: "Password Strength", strength: .moderate)

StandardCheckView(
    checks: checks,
    strength: dummyStrength
)

data class StrengthModel(
    val label: String,
    val strength: Strength,
    val description: String
)

val passwordStrengthModel: StrengthModel
    get() {
        val strength = inputValidator.strength(password)
        val label = displayContent(PASSWORD_STRENGTH_LABEL_KEY)
        val description = getDescriptionFor(strength)

        return StrengthModel(
            label = label,
            strength = strength,
            description = description
        )
    }


private fun getDescriptionFor(strength: Strength): String {
    val key = when (strength) {
        Strength.STRONG -> PASSWORD_STRENGTH_STRONG
        Strength.MODERATE -> PASSWORD_STRENGTH_MODERATE
        Strength.NOT_ACCEPTED -> PASSWORD_STRENGTH_NOT_ACCEPTABLE
        Strength.BLANK -> PASSWORD_STRENGTH_BLANK
    }

    return displayContent(key)
}



public enum Strength {
    case blank, notAccepted, moderate, strong

    public init(name: String) {
        switch name.uppercased() {
        case "STRONG": self = .strong
        case "MODERATE": self = .moderate
        case "NOT_ACCEPTED": self = .notAccepted
        default: self = .blank
        }
    }

    var textColor: Color {
        switch self {
        case .strong: return BankingTheme.colors.onSuccess
        case .moderate: return BankingTheme.colors.onWarning
        case .notAccepted: return BankingTheme.colors.error
        case .blank: return .clear
        }
    }
}

public extension ChangeUserIdValidationPresenter {
    func toStrengthModel() -> StrengthModel? {
        guard let strength = self.strength else {
            return nil
        }

        return StrengthModel(
            label: strength.label,
            strength: Strength(name: strength.strength.name), // uses the String-based init
            description: strength.description
        )
    }
}

StandardCheckView(
    checks: presenter.toCriteriaCheckModels(),
    strength: presenter.toStrengthModel(),
    accessibilityTextForChecks: nil
)

We've noticed Jenkins pipelines are taking a long time to finish, especially after follow-up commits from review comments. This slows down PR merges and blocks others who depend on those changes.

Even with quick approvals, we're often stuck waiting for checks to pass. 
