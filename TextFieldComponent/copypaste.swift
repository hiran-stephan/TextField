// Regex: any char repeated 3 times consecutively
private val REGEX_THREE_IDENTICAL = "(.)\\1\\1".toRegex()

data class NoMoreThanTwoIdenticalInRowRule(
    override val id: Int = VALIDATE_NO_3_IDENTICAL_IN_ROW,
    override val message: String
) : ValidationRule() {
    override fun isValid(item: String): Boolean = !REGEX_THREE_IDENTICAL.containsMatchIn(item)
}

data class NoMoreThanTwoSequentialInRowRule(
    override val id: Int = VALIDATE_NO_SEQUENTIAL_RUN,
    override val message: String
) : ValidationRule() {
    override fun isValid(item: String): Boolean = !hasSequentialRun(item, 3)
}

private fun hasSequentialRun(s: String, minLen: Int): Boolean {
    if (s.length < minLen) return false
    val t = s.lowercase()
    var up = 1
    var down = 1

    fun sameClass(a: Char, b: Char) =
        (a.isDigit() && b.isDigit()) || (a.isLetter() && b.isLetter())

    for (i in 1 until t.length) {
        val a = t[i - 1]; val b = t[i]
        if (!sameClass(a, b)) { up = 1; down = 1; continue }
        when {
            b.code == a.code + 1 -> { up += 1; down = 1 }
            b.code == a.code - 1 -> { down += 1; up = 1 }
            else -> { up = 1; down = 1 }
        }
        if (up >= minLen || down >= minLen) return true
    }
    return false
}

private val passwordValidationRules: List<ValidationRule> = listOf(
    ValidationRule.MinMaxLength(...),
    ValidationRule.AtLeastThreeOfLowercaseUppercaseNumberSymbol(...),
    // your existing allowed-chars rule:
    ValidationRule.NoOtherSpecialCharSpaceRepeatedCharRule(...),
    // NEW:
    NoMoreThanTwoIdenticalInRowRule(
        message = displayContent(CHANGE_PASSWORD_RULE_NO_3_IDENTICAL_TEXT)
    ),
    NoMoreThanTwoSequentialInRowRule(
        message = displayContent(CHANGE_PASSWORD_RULE_NO_SEQUENTIAL_CHARS_TEXT)
    ),
    // Optional blacklist (if BRUL lists restricted words):
    // NoRestrictedWordsRule(banned = listOf("cibc","bank","password"), message = displayContent(...))
)
