/**
 * Checks if a string contains sequential letters or digits
 * ascending or descending, of at least [minLen] characters.
 */
fun String.hasSequentialRun(minLen: Int = 3): Boolean {
    if (length < minLen) return false
    val t = lowercase()
    var up = 1
    var down = 1

    fun sameClass(a: Char, b: Char) =
        (a.isDigit() && b.isDigit()) || (a.isLetter() && b.isLetter())

    for (i in 1 until t.length) {
        val a = t[i - 1]
        val b = t[i]

        if (!sameClass(a, b)) {
            up = 1
            down = 1
            continue
        }

        when {
            b.code == a.code + 1 -> { // ascending
                up += 1
                down = 1
            }
            b.code == a.code - 1 -> { // descending
                down += 1
                up = 1
            }
            else -> {
                up = 1
                down = 1
            }
        }

        if (up >= minLen || down >= minLen) return true
    }
    return false
}


override fun isValid(item: String): Boolean {
    val allowed = allowedPattern.matches(item)
    val noTriples = !RegExPatterns.REGEX_THREE_IDENTICAL.containsMatchIn(item)
    val noSequential = !item.hasSequentialRun(3) // now using extension
    return allowed && noTriples && noSequential
}
