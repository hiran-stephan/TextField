/**
 * Converts a formatted currency string into a plain numeric string.
 *
 * This removes all non-numeric characters except the decimal point.
 * For example: "$1,234.56" becomes "1234.56".
 *
 * @receiver The formatted currency string (e.g., user input or display value).
 * @return A plain numeric string containing only digits and at most one decimal point.
 */
fun String.toPlainAmount(): String {
    return this.replace(Regex("[^\\d.]"), "").trim()
}
