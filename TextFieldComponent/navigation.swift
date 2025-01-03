val REGEX_ALPHANUMERIC_WITH_SPECIAL_CHARS = "^[a-zA-Z0-9'& ,.-]*$".toRegex()

data class AlphanumericWithSpecialCharsValidation(
    override val message: String
) : PatternValidationRule(
    id = VALIDATE_PATTERN_ALPHANUMERIC_WITH_SPECIAL_CHARS,
    message = message,
    pattern = RegExPatterns.REGEX_ALPHANUMERIC_WITH_SPECIAL_CHARS
)

const val VALIDATE_PATTERN_ALPHANUMERIC_WITH_SPECIAL_CHARS = "VALIDATE_PATTERN_ALPHANUMERIC_WITH_SPECIAL_CHARS"

