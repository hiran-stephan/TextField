/**
 * Formats a string to ensure two decimal places are present.
 *
 * Used for formatting an amount value when editing ends.
 * Pads the fractional part to two digits if it's present,
 * or appends ".00" if no decimal part is found.
 *
 * @return A string with a valid two-digit decimal component.
 */
fun String.formattedAmountFieldInput(): String {
    val parts = this.split(".")

    val decimalPart = if (parts.size > 1) {
        // Pad or trim the decimal portion to ensure 2 digits
        val cents = parts[1].padEnd(length = 2, padChar = '0').take(2)
        ".$cents"
    } else {
        // Append ".00" if there is no decimal part
        ".00"
    }

    return parts[0] + decimalPart
}
