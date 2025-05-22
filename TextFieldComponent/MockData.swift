package com.cibc.services.utilities.forms.validation

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class InputValidatorTest {

    private val minMaxRule = MinMaxLength(
        minimum = 8,
        maximum = 20,
        message = "length error"
    )

    private val lettersNumbersRule = AtLeastTwoCharactersAndTwoNumbersRule(
        message = "2 letters and 2 numbers",
        pattern = "^(?=(?:.*[A-Za-z]){2,})(?=(?:.*\\d){2,}).+$"
    )

    private val allowedCharsRule = NoAllowedUsernameCharactersRule(
        message = "no special chars",
        pattern = "^[a-zA-Z0-9]*$"
    )

    private val inputValidator = InputValidator(
        rules = listOf(minMaxRule, lettersNumbersRule, allowedCharsRule)
    )

    @Test
    fun `validate should return UNKNOWN for blank input`() {
        val result = inputValidator.validate("")
        assertTrue(result.all { it.status == ValidationStatus.UNKNOWN })
    }

    @Test
    fun `validate should return VALID for input that passes all rules`() {
        val result = inputValidator.validate("ab123456")
        assertTrue(result.all { it.status == ValidationStatus.VALID })
    }

    @Test
    fun `validate should return INVALID for input with special characters`() {
        val result = inputValidator.validate("ab1234@#")
        val status = result.find { it.ruleId == VALIDATE_USERNAME_ALLOWED_CHAR }?.status
        assertEquals(ValidationStatus.INVALID, status)
    }

    @Test
    fun `strength should return BLANK for empty input`() {
        val status = inputValidator.strength("")
        assertEquals(StrengthStatus.BLANK, status)
    }

    @Test
    fun `strength should return NOT_ACCEPTED if input is invalid`() {
        val status = inputValidator.strength("abc")
        assertEquals(StrengthStatus.NOT_ACCEPTED, status)
    }

    @Test
    fun `strength should return MODERATE if valid but below strong threshold`() {
        val status = inputValidator.strength("abc12345") // < 17 length, valid
        assertEquals(StrengthStatus.MODERATE, status)
    }

    @Test
    fun `strength should return STRONG if valid and length is >= 17`() {
        val status = inputValidator.strength("abc12345678901234") // 17+ chars
        assertEquals(StrengthStatus.STRONG, status)
    }
}


private val usernameTwoLettersTwoDigitsPattern: Regex =
    Regex("^(?=(?:.*[A-Za-z]){2,})(?=(?:.*\\d){2,}).+$")

private val usernameAllowedCharactersPattern: Regex =
    Regex("^[a-zA-Z0-9]*$")



interface RegexPatternProvider {
    val strongPasswordPattern: String
    val emailPattern: String
    val usernameTwoCharTwoNumbers: String
    val usernameNoRestrictedCharacters: String
}

object DefaultRegexPatternProvider : RegexPatternProvider {
    override val strongPasswordPattern = RegExPatterns.REGEX_STRONG_PASSWORD
    override val emailPattern = RegExPatterns.EMAIL_ADDRESS
    override val usernameTwoCharTwoNumbers = RegExPatterns.REGEX_USERNAME_AT_LEAST_TWO_LETTERS_AND_TWO_NUMBERS
    override val usernameNoRestrictedCharacters = RegExPatterns.REGEX_USERNAME_NOT_ALLOWED_CHARACTERS
}

class InputValidator(
    private val rules: List<ValidationRule>,
    private val regexProvider: RegexPatternProvider = DefaultRegexPatternProvider
) {
    // ...

    private fun isStrongPassword(input: String): Boolean =
        isAccepted(input) && (
            StrongPasswordRule(
                message = "Strong Password",
                pattern = regexProvider.strongPasswordPattern
            ).isValid(input) || input.length >= MIN_LENGTH_STRONG_PASSWORD
        )
}

private val testRegexProvider = object : RegexPatternProvider {
    override val strongPasswordPattern = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,}$" // example
    override val emailPattern = ".*"
    override val usernameTwoCharTwoNumbers = ".*"
    override val usernameNoRestrictedCharacters = ".*"
}

private val inputValidator = InputValidator(
    rules = listOf(minMaxRule, lettersNumbersRule, allowedCharsRule),
    regexProvider = testRegexProvider
)
