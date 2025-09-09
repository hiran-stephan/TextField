// src/commonTest/kotlin/com/cibc/services/utilities/forms/validation/InputValidatorTest.kt
package com.cibc.services.utilities.forms.validation

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class InputValidatorTest {

    // --- Production wiring (same shape as app) ---
    private val rules = listOf(
        ValidationRule.MinMaxLength(minimum = 8, maximum = 20, message = "len"),
        ValidationRule.AtLeastTwoCharactersAndTwoNumbersRule(message = "composition"),
        ValidationRule.AllowedUsernameCharactersRule(
            message = "allowed-chars",
            pattern = RegExPatterns.REGEX_USERNAME_ALLOWED_CHARACTERS
        )
    )
    private val inputValidator = InputValidator(rules, DefaultRegexPatternProvider())

    // ----------------------------
    // Existing tests (preserved)
    // ----------------------------

    @Test
    fun `validate should return UNKNOWN for blank input`() {
        val result = inputValidator.validate(input = "")
        assertTrue(result.all { it.status == ValidationStatus.UNKNOWN })
    }

    @Test
    fun `validate should return VALID for input that passes all rules`() {
        // letters+digits, 8–20 long, only allowed chars
        val result = inputValidator.validate(input = "ab123456")
        assertTrue(result.all { it.status == ValidationStatus.VALID }, "$result")
    }

    @Test
    fun `validate should return INVALID for input with disallowed special character`() {
        // old test: find the Allowed-Characters rule status
        val result = inputValidator.validate(input = "ab1234@#`") // backtick ` is NOT allowed
        val status = result.find { it.ruleId == ValidationRule.AllowedUsernameCharactersRule.ID }?.status
            ?: result.find { it.ruleId == VALIDATE_USERNAME_ALLOWED_CHAR }?.status // fallback if you still use the constant
        assertEquals(ValidationStatus.INVALID, status)
    }

    @Test
    fun `strength should return BLANK for empty input`() {
        val status = inputValidator.strength(input = "")
        assertEquals(StrengthStatus.BLANK, status)
    }

    @Test
    fun `strength should return NOT_ACCEPTED if input is invalid`() {
        val status = inputValidator.strength(input = "abc") // too short & fails composition
        assertEquals(StrengthStatus.NOT_ACCEPTED, status)
    }

    @Test
    fun `strength should return MODERATE if valid but below strong threshold`() {
        val status = inputValidator.strength(input = "abc12345") // valid, < 17 chars
        assertEquals(StrengthStatus.MODERATE, status)
    }

    @Test
    fun `strength should return STRONG if valid and length is greater than or equal to 17`() {
        val status = inputValidator.strength(input = "abc12345678901234") // 17 chars, valid
        assertEquals(StrengthStatus.STRONG, status)
    }

    // -----------------------------------------
    // New username regex coverage (added)
    // -----------------------------------------

    @Test
    fun `allowed specials should all pass`() {
        // Space, - . , ~ ! @ # & _ : $ ^ * + ' / ? = ;
        val allowedSpecials = " -.,~!@#&_:${'$'}^*+'/?=;"
        val sample = "Az09$allowedSpecialsZ9" // wrap with alnum to avoid leading-empty pitfalls
        assertTrue(RegExPatterns.REGEX_USERNAME_ALLOWED_CHARACTERS.matches(sample), sample)

        val result = inputValidator.validate(sample)
        assertTrue(result.all { it.status == ValidationStatus.VALID }, "$result")
    }

    @Test
    fun `parentheses are rejected`() {
        listOf("John(Doe)99", "(user)1234", "A)B123456", "A(B123456").forEach { s ->
            assertFalse(RegExPatterns.REGEX_USERNAME_ALLOWED_CHARACTERS.matches(s), s)
            val result = inputValidator.validate(s)
            val status = result.find { it.ruleId == ValidationRule.AllowedUsernameCharactersRule.ID }?.status
            assertEquals(ValidationStatus.INVALID, status, s)
        }
    }

    @Test
    fun `disallowed symbols like backtick percent double-quote backslash angle-brackets are rejected`() {
        val badSamples = listOf(
            "name`tick",   // backtick
            "name%perc",   // percent
            "name\"quote", // double-quote
            "name\\slash", // backslash
            "name<less",   // <
            "name>more"    // >
        )
        badSamples.forEach { s ->
            val result = inputValidator.validate(s)
            val status = result.find { it.ruleId == ValidationRule.AllowedUsernameCharactersRule.ID }?.status
            assertEquals(ValidationStatus.INVALID, status, s)
        }
    }

    @Test
    fun `too short fails length rule only`() {
        val result = inputValidator.validate("A1b2c3") // 6 chars
        val lenStatus = result.find { it.ruleId == ValidationRule.MinMaxLength.ID }?.status
        assertEquals(ValidationStatus.INVALID, lenStatus)
    }

    @Test
    fun `not enough numbers fails composition rule`() {
        val result = inputValidator.validate("Abcdefgh") // 0 digits
        val compStatus = result.find { it.ruleId == ValidationRule.AtLeastTwoCharactersAndTwoNumbersRule.ID }?.status
        assertEquals(ValidationStatus.INVALID, compStatus)
    }

    // -----------------------------------------
    // Provider mapping sanity (optional but nice)
    // -----------------------------------------

    @Test
    fun `provider returns the same whitelist pattern used by the rule`() {
        val providerPattern = DefaultRegexPatternProvider().usernameAllowedCharacters.pattern.toString()
        val constPattern = RegExPatterns.REGEX_USERNAME_ALLOWED_CHARACTERS.pattern.toString()
        assertEquals(constPattern, providerPattern)
    }
}
