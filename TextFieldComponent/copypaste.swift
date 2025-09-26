private fun normalizePattern(pattern: String): String {
    val parts = pattern.split('.').toMutableList()
    if (parts.size < 3) return pattern

    val major = parts[0]
    val minor = parts[1]
    val patch = parts[2]

    // If minor is a wildcard, force patch to wildcard too. (M.X.P -> M.X.X)
    if (minor.equals("x", true) && !patch.equals("x", true)) {
        parts[2] = "X"
    }
    return parts.joinToString(".")
}
