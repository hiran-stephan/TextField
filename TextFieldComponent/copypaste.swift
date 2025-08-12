/**
 * Checks if a string contains sequential letters or digits
 * (ascending or descending) of at least [minLen] characters.
 */
fun String.hasSequentialRun(minLen: Int = 3): Boolean {
    if (length < minLen) return false

    for (i in 0..length - minLen) {
        var sequential = true
        for (j in 0 until minLen - 1) {
            val diff = this[i + j + 1].code - this[i + j].code
            if (diff != 1 && diff != -1) {
                sequential = false
                break
            }
        }
        if (sequential) return true
    }
    return false
}
