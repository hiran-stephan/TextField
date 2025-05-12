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
