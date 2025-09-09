// test-only (commonTest or jvmTest)
object FakeRegexPatternProvider : RegexPatternProvider {
    override val usernameAllowedCharacters =
        RegExPatterns.REGEX_USERNAME_ALLOWED_CHARACTERS
    override val usernameTwoCharTwoNumbers =
        RegExPatterns.REGEX_USERNAME_AT_LEAST_TWO_LETTERS_AND_TWO_NUMBERS
    override val usernameNoRestrictedCharacters =
        RegExPatterns.REGEX_USERNAME_NO_RESTRICTED_CHARACTERS

    // <-- mock email so tests don't need platform actuals
    override val emailSimple: Regex = Regex(".*")
}
