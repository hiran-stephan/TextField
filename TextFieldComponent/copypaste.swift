fun String.hasSequentialRun(minLen: Int = 3): Boolean {
    if (length < minLen) return false
    val s = lowercase()                      // (1) case-insensitive

    for (i in 0..s.length - minLen) {
        var sequential = true
        var dir: Int? = null                 // (2) track direction: +1 or -1

        for (j in 0 until minLen - 1) {
            val step = s[i + j + 1].code - s[i + j].code
            if (step != 1 && step != -1) {   // not adjacent -> break
                sequential = false
                break
            }
            if (dir == null) dir = step      // first step sets direction
            else if (step != dir) {          // direction must stay the same
                sequential = false
                break
            }
        }
        if (sequential) return true
    }
    return false
}
