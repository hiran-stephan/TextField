// 3 identical chars in a row (any char)
val REGEX_THREE_IDENTICAL = "(.)\\1\\1".toRegex()

// sequential letters/digits (min run = 3)
fun hasSequentialRun(s: String, minLen: Int = 3): Boolean {
    if (s.length < minLen) return false
    val t = s.lowercase()
    var up = 1; var down = 1

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

data class NoOtherSpecialCharSpaceRepeatedCharRule(
    override val id: Int = VALIDATE_NO_REPEATED_SPECIAL_CHAR,
    override val message: String
) : ValidationRule<Any>() { // keep your generic base; or use <String> if you prefer
    private val allowedPattern = RegExPatterns.REGEX_CONTAINS_NO_OTHER_SPECIAL_CHAR_REPEATED_CHAR

    override fun isValid(item: Any): Boolean {
        val s = item.toString()
        val allowed = allowedPattern.matches(s)               // old behavior
        val noTriples = !RegExPatterns.REGEX_THREE_IDENTICAL.containsMatchIn(s)
        val noSequential = !hasSequentialRun(s, 3)
        return allowed && noTriples && noSequential
    }
}
